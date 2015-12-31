require 'minitest/autorun'
require 'minitest/reporters'
require 'majak'
require 'tcr'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

TCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/tcr_cassettes'
  c.hook_tcp_ports = [2947]
end
