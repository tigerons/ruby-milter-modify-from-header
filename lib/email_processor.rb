# frozen_string_literal: true

require_relative 'configuration'

EMAIL_FORMAT = /(?<email_address>([a-zA-Z0-9_.-]+)@([a-zA-Z0-9_.-]+)\.([a-zA-Z]{2,5}))/.freeze
EMAIL_FORMAT_2 = /<(?<email_address>[^>]+)>/.freeze
# Module responsible for processing email addresses.
module EmailProcessor
  # Returns the email address extracted from the given address line.
  #
  # @param address_line [String] The address line from which to extract the email address.
  # @return [String, nil] The extracted email address, or nil if no valid email address found.
  # example return_email_address(ssss <ttt@wp.pl>) output: ttt@wp.pl

  def self.return_email_address(address_line)
    match_data = address_line.match(EMAIL_FORMAT) || address_line.match(EMAIL_FORMAT_2)
    match_data['email_address'].downcase if match_data
  end

  def self.valid_email?(email_address)
    false if email_address.nil? || email_address.empty?
  end

  def self.incoming_email?(email_address)
    !company_domains?(email_address)
  end

  # Checks if the given address is from a company domain.
  #
  # @param address [String] The email address to check.
  # @return [Boolean] True if the address belongs to a company domain, false otherwise.

  def self.company_domains?(address)
    domains = Configuration.instance.domains
    domains.any? { |domain| address.include?(domain) }
  end
end
