require 'vincenty'

module Majak
  class Waypoint < Vincenty
    attr_accessor :id

    def initialize lat, lon, id
      @id = id.to_s.rjust(3, '0')

      super(lat,lon)
    end

    def self.nmea_checksum sentence
      sentence[1..-1].split("").inject(0) {|x,y| x^y.bytes.first}.to_s(16).upcase
    end

    def to_nmea
      nmea_lat = degrees_to_nmea lat, :lat
      nmea_lon = degrees_to_nmea lon, :lon

      sentence = "$GPWPL,#{nmea_lat},#{nmea_lon},#{id}"
      "#{sentence}*#{Waypoint.nmea_checksum(sentence)}\n"
    end

    def lat
      latitude.to_degrees
    end

    def lon
      longitude.to_degrees
    end

    private

    def degrees_to_nmea(deg, deg_type)
      d = deg.abs.to_i
      m = (((deg.abs - d) * 60.0) * 10000.0).round / 10000.0

      case deg_type
      when :lat then "%02d%07.4f,%s" % [d, m, (deg < 0) ? "S" : "N"]
      when :lon then "%03d%07.4f,%s" % [d, m, (deg < 0) ? "W" : "E"]
      end
    end
  end
end
