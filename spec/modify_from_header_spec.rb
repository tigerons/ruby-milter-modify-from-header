# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ModifyFromHeader do
  let(:my_milter) { described_class.new }

  after do
    my_milter.instance_variable_set(:@headers, {})
  end

  describe '#process_email' do
    from_changed = 'example@example.com'
    context 'when incoming email' do
      it 'changes the From header' do
        from_header = 'John Doe <example@example.com>'
	allow(EmailProcessor).to receive(:return_email_address).with(from_header).and_return(from_changed)
        allow(EmailProcessor).to receive(:incoming_email?).with(from_changed).and_return(true)
        allow(EmailProcessor).to receive(:valid_email?).with(from_changed).and_return(true)

        response = my_milter.process_email(from_header)
	Milter::Milter::Response.change_header('From', from_changed)
        expect(response).to include(Milter::Milter::Response.change_header('From', from_changed))
      end
    end

    context 'when outgoing email' do
      it 'does not change the From header' do
        from_header = 'example@ifirma.pl'
        allow(EmailProcessor).to receive(:incoming_email?).with(from_header).and_return(false)

        response = my_milter.process_email(from_header)
        expect(response).to include(Milter::Milter::Response.continue)
      end
    end
   
    context 'when invalid email' do
      it 'includes Milter::Milter::Response.continue' do
        from_header = 'faritail+johndoe!@example.com'
        email_address = nil
        allow(EmailProcessor).to receive(:valid_email?).with(email_address).and_return(false)

        response = my_milter.process_email(from_header)
        expect(response).to include(Milter::Milter::Response.continue)
      end 
    end
  end

  describe '#headers' do
    it 'adds a value to specified header' do
      response = my_milter.header('From', 'jkowalski@gmail.com')
      expect(response).to include(Milter::Milter::Response.continue)
    end
  end

  describe '#body' do
    let(:my_milter_spy) { instance_spy(described_class) }

    from = 'sender@example.com'

    before do
      allow(my_milter).to receive(:process_email)
      my_milter_spy.process_email(from)
      my_milter.body('data')
    end

    context 'when "From" header is present' do
      before do
        my_milter.instance_variable_set(:@headers, { 'From' => [from] })
      end

      it 'calls process_email with the correct sender' do
        expect(my_milter_spy).to have_received(:process_email).with(from)
      end
    end

    context 'when "From" header is nil or absent' do
      it 'does not call process_email when "From" header is nil' do
        my_milter.instance_variable_set(:@headers, { 'From' => nil })

        expect(my_milter).not_to have_received(:process_email)
      end

      it 'does not call process_email when "From" header is an empty array' do
        my_milter.instance_variable_set(:@headers, { 'From' => [] })

        expect(my_milter).not_to have_received(:process_email)
      end
    end
  end
end
