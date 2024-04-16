#!/usr/bin/ruby
# frozen_string_literal: true

require 'daemons'
require_relative '../lib/configuration'
require_relative '../lib/modify_from_header'

Daemons.run_proc('milter_modify_from_header',
  :dir => '/var/run/milter_modify_from_header',
  :log_dir => '/var/log',
  :log_output => true) do
  host = Configuration.instance.host
  port = Configuration.instance.port

  Milter.register(ModifyFromHeader)
  Milter.start(host, port)
end
