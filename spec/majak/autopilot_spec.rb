# Autopilot Test Program
#
# This small program will be used to test how the autopilot will act going
# between certain waypoints. It will simulate movement from a starting point
# moving toward the next waypoint then when it gets there, it will turn
# toward the next waypoint and continue.
require 'spec_helper'

describe Majak::Autopilot do
  describe "when starting up" do
    before do
      @autopilot = Majak::Autopilot.new 'http://majak:2947'
      @autopilot.load_waypoints 'spec/fixtures/waypoints.txt'
    end

    it "should load waypoints from a text file" do
      @autopilot.waypoints.count.must_equal 2
    end

    it "should read data from the digital compass"

    it "should connect to gpsd and start reading data" do
      socket = Minitest::Mock.new
      socket.expect :print, nil, ["?WATCH={\"enable\":true,\"json\":true}\n"]
      socket.expect :gets, nil

      TCPSocket.stub :open, socket do
        @autopilot.start
      end

      socket.verify
    end
  end

  describe "when running" do
    it "should turn"
    it "should detect if it's not moving"
  end
end

#class AutopilotTest < Minitest::Test
#  def setup
#    current = JSON.parse open('test/fixtures/current.txt').read, symbolize_names: true
#    current[:location] = Vincenty.new current[:lat], current[:lon]
#
#    @autopilot = Majak::Autopilot.new GPS_SERVER_URI
#    @autopilot.load_waypoints 'test/fixtures/waypoints.txt'
#    @autopilot.current = current
#  end
#
#  #def test_receiving_data
#  #  TCR.use_cassette('gps_data') do |cassette|
#  #    @autopilot.data_limit = cassette.sessions.first.length
#  #    @autopilot.receive_data
#  #  end
#  #end
#
#  def test_degrees_to_turn
#    #assert @autopilot.current_bearing == '120', 'Incorrect direction'
#  end
#
#  def test_needs_adjustment
#    #@autopilot.send(:current=, 'sup') 
#    #assert @autopilot.course_needs_adjustment? == true
#  end
#
#  def test_time_for_adjustment
#  end
#
#  def test_turn_when_at_waypoint
#    #skip 'until I can simulate movement'
#  end
#end
