require 'spec_helper'

describe Majak::Waypoint do
  before do
    @waypoint = Majak::Waypoint.new 30, -90, 1
  end

  describe '#to_nmea' do
    it 'should return a valid NMEA sentence' do
      assert @waypoint.to_nmea == "$GPWPL,2960.0000,N,09000.0000,W,001*6C\n", @waypoint.to_nmea
    end
  end
end

