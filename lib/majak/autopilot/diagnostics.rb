module Majak
  module Autopilot
    class Diagnostics
      class MissingEnvironmentVariable < StandardError; end

      def self.run
        check_environment_variables
        check_gps_server
        #check_waypoints
        #check_tiller_motor
      end

      private

      def self.check_environment_variables
        Autopilot::REQUIRED_ENV.each do |env|
          unless ENV[env]
            raise MissingEnvironmentVariable, env
          end
        end
      end

      def self.check_gps_server
        uri = URI.parse ENV['GPS_SERVER_URI']
        #puts uri.inspect
        x =TCPSocket.open 'localhost', 3000
      end
    end
  end
end
