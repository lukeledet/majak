module Majak
  module CLI
    class Autopilot < Thor
      desc 'start', 'go'
      def start gps_server_uri=nil, gps_waypoints=nil
        gps_server_uri ||= ENV['GPS_SERVER_URI']
        gps_waypoints ||= ENV['GPS_WAYPOINTS']
        gps_waypoints = File.expand_path(gps_waypoints)

        daemon_options = {
          backtrace: true,
          app_name: 'autopilot',
          dir_mode: :normal,
          dir: '/tmp',
          log_dir: '/var/log/majak',
          log_output: true
        }

        app = Daemons.call(daemon_options) do
          autopilot = Majak::Autopilot.new gps_server_uri
          autopilot.load_waypoints gps_waypoints
          autopilot.start
        end

        puts 'Autopilot started'
      end

      desc 'stop', 'nogo'
      def stop
        # When the daemon is killed it removes the pid
        pid = open('/tmp/autopilot.pid').read
        Process.kill 'TERM', pid.to_i

        puts 'Autopilot stopped'
      end
    end
  end
end
