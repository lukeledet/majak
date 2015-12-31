require 'eventmachine'
require 'json'
require 'socket'
require 'uri'
require 'vincenty'
require 'rb-pid-controller'

module Majak
  module Autopilot
    class Server # or Daemon, Runner, or some other name
      BEARING_THRESHOLD = 3 #degrees
      ADJUSTMENT_FREQUENCY = 5 #seconds

      attr_accessor :current
      attr_accessor :current_destination
      attr_accessor :data_limit
      attr_reader :waypoints

      def initialize gps_uri
        @gps_uri = URI.parse gps_uri
        @last_adjusted_at = Time.now
        @pid = PIDController::PID.new
        @pid.set_consign(0.0)
      end

      def start
        EventMachine.kqueue = true
        EventMachine.run do
          data_channel = EventMachine::Channel.new
          data_channel.subscribe do |data|
            @current = data
            @current[:location] = Vincenty.new @current[:lat], @current[:lon]

            if course_needs_adjustment? # && time_for_adjustment?
              puts degrees_to_turn
              adjustment = @pid << degrees_to_turn
              puts adjustment
              #motor.make_adjustment adjustment
            else
              #motor.turn_off!
              # Or should it straighten out first? probably not, since it's been
              # getting closer to center the whole time anyway
            end
          end

          EventMachine.connect @gps_uri.host, @gps_uri.port, GPSClientJSON, data_channel
          EventMachine.watch_file '/tmp/waypoints.txt', WaypointHandler, data_channel
        end
      end

      def start_old
        receive_data do |data|
          next unless data[:class] == 'TPV'

          @current = data
          @current[:location] = Vincenty.new @current[:lat], @current[:lon]

          if course_needs_adjustment? && time_for_adjustment?
            #puts 'here we go!!!!!!!!!!!!!!!!!'
            puts "Current:"
            puts "  position: #{@current[:lat]}, #{@current[:lon]}"
            puts "  speed: #{@current[:speed]} m/s"

            degrees = degrees_to_turn
            dir = degrees < 1 ? 'left' : 'right'
            puts "Adjusting by #{degrees} to the #{dir}"

            # Turn motor on for x seconds in y direction
            # How do we determine x?

            # POSSIBLE INTERFACES
            Motor.turn 'left', degrees_to_turn

            @motor.turn :port, degrees_to_turn
            @motor.turn :port, 5 # seconds

            turn :port, degrees_to_turn

            # Another method could be to "begin turning" get data again then stop turning when we're going in the right direction
            begin_turn :port, degrees_to_turn

            # Take into account the speed we are going, turn on the motor for a shorter period of time if we're going faster. turn on the motor long enough for what should put us on course then straighten it out, don't just push and pull all day long

            # If our heading is due north and we need to go 2 degrees east, how long will it take for the boat to be pointing at 2 degrees if I turn the tiller 2 degrees?

            # Turn the motor on for x seconds
            # Wait y seconds
            # Turn the motor on in reverse for x seconds
            @last_adjusted_at = Time.now
          end
        end
      end

      def receive_data
        @gps_socket = TCPSocket.open @gps_uri.host, @gps_uri.port

        # Tell the GPS unit to stream JSON data to the socket
        @gps_socket.print "?WATCH={\"enable\":true,\"json\":true}\n"

        while line = @gps_socket.gets
          yield JSON.parse(line, symbolize_names: true)
        end
      end

      def load_waypoints pathname
        lines = File.readlines(pathname).map {|x| x.split(',') }
        @waypoints = lines.map.with_index {|wp,i| Waypoint.new wp[0], wp[1], i}
        @current_destination = @waypoints.first
      end

      def current_bearing
        @current[:location].distanceAndAngle(@current_destination).bearing.to_d
      end

      def course_needs_adjustment?
        degrees_off_course = [
          current_bearing - @current[:track],
          360 + @current[:track] - current_bearing
        ].min

        degrees_off_course > BEARING_THRESHOLD
      end

      def time_for_adjustment?
        Time.now - @last_adjusted_at > ADJUSTMENT_FREQUENCY
      end

      def degrees_to_turn
        # From here: http://gmc.yoyogames.com/index.php?showtopic=532420
        ((((bearing - heading) % 360) + 540) % 360) - 180
      end

      def motor
        @motor ||= Motor.new
      end
    end
  end
  class WaypointHandler < EventMachine::FileWatch
    def initialize gps_channel
      @gps_channel = gps_channel

      # I should probably send the waypoints/route when starting up
      # but I don't know if this is the right place to do it yet
    end

    def file_modified
      puts "FILE MODIFIED at #{Time.now}"

      file = open(path).read

      waypoints = file.split("\n").map.with_index do |line,i|
        id = (i+1).to_s.rjust(3, '0')
        coords = line.split(',')

        Majak::Waypoint.new coords[0], coords[1], id
      end

      route = Majak::Route.new waypoints

      route.to_nmea.each do |msg|
        puts msg
        @gps_channel.push msg
      end
    end

    def file_deleted
      puts 'Deleted'
    end

    def file_moved
      puts 'Moved'
    end
  end
end
