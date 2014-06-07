require 'thor'
require 'daemons'

require 'majak/cli/autopilot'

module Majak
  module CLI
    class Base < Thor
      desc 'autopilot', 'autopilot shit'
      subcommand 'autopilot', Autopilot
    end
  end
end
