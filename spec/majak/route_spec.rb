require 'spec_helper'

describe Majak::Route do
  before do
    waypoints = 5.times.map {|i| Majak::Waypoint.new 30, -90, i }
    @route = Majak::Route.new waypoints
  end

  it 'should have a list of waypoints' do
    assert @route.waypoints.count == 5
  end

  describe "#to_nmea" do
    it 'should never send a sentence longer than 80 characters' do
      @route.to_nmea.any? {|x| x.length > 80}.must_equal false
    end

    it 'should give valid nmea for the entire route' do
      valid_nmea = %W{
        $GPWPL,2960.0000,N,09000.0000,W,000*6D\n
        $GPWPL,2960.0000,N,09000.0000,W,001*6C\n
        $GPWPL,2960.0000,N,09000.0000,W,002*6F\n
        $GPWPL,2960.0000,N,09000.0000,W,003*6E\n
        $GPWPL,2960.0000,N,09000.0000,W,004*69\n
        $GPRTE,1,1,w,0,000,001,002,003,004*B\n
      }

      @route.to_nmea.must_equal valid_nmea
    end

    it 'should break up long route sentences' do
      valid_nmea = %W{
        $GPRTE,7,1,w,0,000,001,002,003,004,005,006,007,008,009,010,011,012,013,014*D\n
        $GPRTE,7,2,w,0,015,016,017,018,019,020,021,022,023,024,025,026,027,028,029*F\n
        $GPRTE,7,3,w,0,030,031,032,033,034,035,036,037,038,039,040,041,042,043,044*A\n
        $GPRTE,7,4,w,0,045,046,047,048,049,050,051,052,053,054,055,056,057,058,059*C\n
        $GPRTE,7,5,w,0,060,061,062,063,064,065,066,067,068,069,070,071,072,073,074*F\n
        $GPRTE,7,6,w,0,075,076,077,078,079,080,081,082,083,084,085,086,087,088,089*D\n
        $GPRTE,7,7,w,0,090,091,092,093,094,095,096,097,098,099*12\n
      }

      @route.waypoints = 100.times.map {|i| Majak::Waypoint.new 30, -90, i }

      @route.to_nmea[-7..-1].must_equal valid_nmea
    end
  end
end
