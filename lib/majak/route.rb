require 'pry'
module Majak
  class Route
    attr_accessor :waypoints

    def initialize waypoints
      @waypoints = waypoints
    end

    def to_nmea
      sentences = waypoints.map(&:to_nmea)

      # Split up the waypoint ids into chunks of 61 characters
      # including the commas separating them without breaking any
      # ids into multiple chunks
      ids = waypoints.map(&:id).join(',')
      waypoint_names = ids.scan(/.{1,60}\b|.{1,60}/).map {|x| x.chomp(',') }

      routes = waypoint_names.map.with_index do |names, i| 
        sentence = "$GPRTE,#{waypoint_names.count},#{i+1},w,0,#{names}"
        checksum = Majak::Waypoint.nmea_checksum(sentence)

        "#{sentence}*#{checksum}\n"
      end

      sentences + routes
    end
  end
end
