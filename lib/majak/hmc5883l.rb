require 'i2c'
require 'cmath'

# @TODO Add methods for configuring the 2 config registers and mode
# @TODO Add a method to configure the magnetic declination: http://www.magnetic-declination.com/
# @TODO Add a way to run the self test
# @TODO Add support for the DRDY pin
# Reference: http://www.adafruit.com/datasheets/HMC5883L_3-Axis_Digital_Compass_IC.pdf
class HMC5883L
  I2C_ADDRESS = 0x1e

  attr_accessor :raw

  def initialize i2c_device
    @i2c = I2C.create i2c_device

    # Set data rate, sample size and measurement mode
    @i2c.write I2C_ADDRESS, 0x00, 0x08

    # Set gain
    @i2c.write I2C_ADDRESS, 0x01, 0x38

    # Set continuous mode
    @i2c.write I2C_ADDRESS, 0x02, 0x00
  end

  def ready?
    status = @i2c.read(I2C_ADDRESS, 1, 0x09).unpack('B*').first
    status[-2..-1] == '01'
  end

  def read
    @raw = @i2c.read I2C_ADDRESS, 6, 0x03

    # 16-bit signed integers using big endian
    x, z, y = @raw.unpack('s>*')

    return x, y, z
  end

  def read_loop
    while true
      if ready?
        yield read
      end
      sleep 0.06
    end
  end

  def get_heading x,y
    magnetic_declination = 0.00814486984

    heading = CMath.atan2 y, x
    heading += magnetic_declination

    if heading < 0
      heading += 2 * Math::PI
    end

    if heading > 2 * Math::PI
      heading -= 2 * Math::PI
    end

    # Convert to degrees 
    heading * 180 / Math::PI
  end
end
