require 'spec_helper'

describe Majak::Autopilot::Diagnostics do
  describe "when checking for environment variables" do
    it "should raise an exception on any missing vars" do
      var = Majak::Autopilot::REQUIRED_ENV.first 
      old = ENV.delete var

      assert_raises(Majak::Autopilot::Diagnostics::MissingEnvironmentVariable) do
        Majak::Autopilot::Diagnostics.run
      end

      ENV[var] = old
    end
  end

  describe "when checking for a connection to the GPS server" do
    it "should raise an exception on connection failure" do
      assert_raises(StandardError) do
        Majak::Autopilot::Diagnostics.run
      end
    end
  end
end
