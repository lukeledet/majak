require 'eventmachine'

module Majak
  class Autopilot
    class GPSClientNMEA < EventMachine::Connection
      def initialize channel
        @channel = channel
      end

      def post_init
        send_data '?WATCH={"enable":true,"json":false,"nmea":true}'

        puts 'GPS Client Connected'
      end

      def receive_data data
        @channel.push data
      end
    end
  end
end
