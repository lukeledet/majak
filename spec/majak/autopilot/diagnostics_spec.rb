require 'spec_helper'

describe Majak::Autopilot::Diagnostics do
  describe "when checking for environment variables" do
    it "should raise an exception on any missing vars" do
      var = Majak::Autopilot::REQUIRED_ENV.first 
      ENV[var] = nil

      assert_raises(Majak::Autopilot::Diagnostics::MissingEnvironmentVariable) do
        Majak::Autopilot::Diagnostics.run
      end
    end
  end
end
