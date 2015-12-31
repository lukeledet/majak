module Majak
  module Autopilot
    class Motor
      # Pins use GPIO numbering
      PWM_PIN = 18 
      CONTROL_PIN_PORT= 4
      CONTROL_PIN_STARBOARD = 17

      PIBLASTER = '/dev/pi-blaster'

      def initialize
        # Use GPIO pin numbering
#        @gpio = WiringPi::GPIO.new 1
#        @gpio.mode CONTROL_PIN_PORT, OUTPUT
#        @gpio.mode CONTROL_PIN_STARBOARD, OUTPUT
      end

      def turn direction, degrees
        set_direction direction
        on!
        sleep 5
        off!
      end

      def on!
        IO.write PIBLASTER, "#{PWM_PIN}=0.8\n"
      end

      def off!
        IO.write PIBLASTER, "#{PWM_PIN}=0\n"
      end

      def make_adjustment adjustment
        if adjustment > 0
          set_direction :port
        else
          set_direction :starboard
        end

        IO.write PIBLASTER, "#{PWM_PIN}=#{adjustment.abs}\n"
      end

      def set_direction dir
        if dir == 'port'
#          @gpio.write CONTROL_PIN_PORT, 1
#          @gpio.write CONTROL_PIN_STARBOARD, 0
        else
#          @gpio.write CONTROL_PIN_PORT, 0
#          @gpio.write CONTROL_PIN_STARBOARD, 1
        end
      end
    end
  end
end
