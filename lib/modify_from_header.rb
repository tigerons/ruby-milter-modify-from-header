# frozen_string_literal: true

require 'milter'
require 'yaml'
require 'date'
require_relative 'configuration'
require_relative 'email_processor'

# MyMilter class represents a mail filter that processes incoming emails.
# It provides methods to process email headers and make necessary modifications.
class ModifyFromHeader < Milter::Milter
  attr_reader :headers

  # Processes the email based on the sender's header.
  #
  # If the email is incoming, it changes the 'From' header to the appropriate address.
  # Exmaple: input From: "Jan Kowalski <jkowalski@gmail.com>" output: "<jkowalski@gmail.com>"
  #
  # Parameters:
  # - from_header: [String] The sender's email header.
  #
  # Returns:
  # - [Array<Response, Response>] An array containing Response objects.

  def initialize
    super
    @headers = {}
    @configuration = Configuration.instance
  end

  def header(name, value)
    @headers[name] = [] if @headers[name].nil?
    @headers[name] << value
    Response.continue
  end

  def process_email(from_header)
    p email_address = EmailProcessor.return_email_address(from_header)
    return Response.continue unless EmailProcessor.valid_email?(email_address)

    return Response.continue unless EmailProcessor.incoming_email?(email_address)

    [Response.change_header('From', email_address.to_s), Response.continue]
  end

  def current_datetime
    Time.now.strftime('%Y-%m-%d %H:%M:%S')
  end

  def body(_data)
    from_header = @headers['From']
    puts "#{current_datetime} #{from_header}"
    process_email(from_header.first) unless from_header.nil? || from_header.empty?
  end
end
