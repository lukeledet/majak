require 'majak/autopilot/diagnostics'
require 'majak/autopilot/gps_client_json'
require 'majak/autopilot/motor'
require 'majak/autopilot/server'

module Majak
  module Autopilot
    REQUIRED_ENV = %w{
      GPS_SERVER_URI
      WAYPOINTS_PATH
    }
  end
end
