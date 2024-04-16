# frozen_string_literal: true

require 'singleton'
require 'yaml'
# The Configuration class represents the application configuration, containing settings and options.
# It allows access to various configuration parameters.
class Configuration
  # Initializes a new configuration instance with default settings.
  #
  # Returns:
  # - [Configuration] A new configuration instance.
  include Singleton

  attr_reader :port, :host, :domains

  def initialize
    load_config
  end

  private

  def load_config
    config = YAML.load_file('/etc/ruby-milter/modify_from_header_config.yml') rescue {}
    @port = config['port'] || 8888
    @host = config['host'] || 'localhost'
    @domains = config['domains'] || []
  end
end
