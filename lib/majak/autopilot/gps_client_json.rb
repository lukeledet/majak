require 'eventmachine'

module Majak
  module Autopilot
    class GPSClientJSON < EventMachine::Connection
      def initialize channel
        @channel = channel
      end

      def post_init
        send_data '?WATCH={"enable":true,"json":true}'

        puts 'GPS Client Connected'
      end

      def receive_data data
        data.split("\n").map do |line|
          JSON.parse(line, symbolize_names: true)
        end.select do |line|
          line[:class] == 'TPV'
        end.each do |line|
          @channel.push line
        end
      end
    end
  end
end
