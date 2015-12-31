module Majak
  module CLI
    class Autopilot < Thor
      desc 'start', 'go'
      def start gps_server_uri=nil, gps_waypoints=nil
        gps_server_uri ||= ENV['GPS_SERVER_URI']
        gps_waypoints ||= ENV['WAYPOINTS_PATH']
        gps_waypoints = File.expand_path(gps_waypoints)

        autopilot = Majak::Autopilot.new gps_server_uri
        autopilot.load_waypoints gps_waypoints
        autopilot.start

        puts 'Autopilot started'
      end
    end
  end
end
