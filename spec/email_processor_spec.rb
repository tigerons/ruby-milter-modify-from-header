# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EmailProcessor do
  before do
    allow(Configuration.instance).to receive(:domains).and_return(['ifirma.pl', 'power.com.pl', 'powermedia.com.pl'])
  end

  describe '.return_email_address' do
    context 'when given valid address line' do
      it 'returns the extracted email address' do
        address_line = 'John Doe <john.doe@example.com>'
        expect(described_class.return_email_address(address_line)).to eq('john.doe@example.com')
      end
    end

    context 'when given invalid address line' do
      it 'returns nil' do
        address_line = 'Not an email address'
        expect(described_class.return_email_address(address_line)).to be_nil
      end
      it 'returns nil if not match' do
        address_line = 'faritail+johndoe!@gmail.com'
        expect(described_class.return_email_address(address_line)).to be_nil
      end
    end
  end

  describe '.valid_email?' do
    context 'when given nil' do
      it 'return false' do
        address_line = nil
	expect(described_class.valid_email?(address_line)).to be false
      end
    end
  end

  describe '.incoming_email?' do
    context 'when given an email address from a company domain' do
      it 'returns false from ifirma.pl' do
        address_email = 'john.doe@ifirma.pl'

        expect(described_class.incoming_email?(address_email)).to be false
      end

      it 'returns false from antoher company domain - power.com.pl' do
        address_email = 'john.doe@power.com.pl'
        expect(described_class.incoming_email?(address_email)).to be false
      end

      it 'returns false from antoher company domain - powermedia.com.pl' do
        address_email = 'john.doe@powermedia.com.pl'
        expect(described_class.incoming_email?(address_email)).to be false
      end
    end

    context 'when given an email address not from a company domain' do
      it 'returns true' do
        address_email = 'john.doe@gmail.com'
        expect(described_class.incoming_email?(address_email)).to be true
      end

      it 'returns true from other domain - wp.pl' do
        address_email = 'john.doe@wp.pl'
        expect(described_class.incoming_email?(address_email)).to be true
      end

      it 'returns true from other domain - onet.pl' do
        address_email = 'john.doe@onet.pl'
        expect(described_class.incoming_email?(address_email)).to be true
      end
    end
  end

  describe '.company_domains?' do
    let(:company_domains) { ['ifirma.pl', 'power.com.pl', 'powermedia.com.pl'] }

    before do
      allow(Configuration.instance).to receive(:domains).and_return(company_domains)
    end

    context 'when given an email address from a company domain' do
      it 'returns true for ifirma.pl' do
        address = 'john.doe@ifirma.pl'
        expect(described_class.company_domains?(address)).to be true
      end

      it 'returns true from another company domain - power.com.pl' do
        address = 'john.doe@power.com.pl'
        expect(described_class.company_domains?(address)).to be true
      end
    end

    context 'when given an email address not from a company domain' do
      it 'returns false' do
        address = 'john.doe@gmail.com'
        expect(described_class.company_domains?(address)).to be false
      end
    end
  end
end
