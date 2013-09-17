# encoding: utf-8
# http://blog.csdn.net/coolypf/article/details/8686588
# Code from https://on4wp7.codeplex.com/SourceControl/changeset/view/21483#353936
# http://blog.csdn.net/coolypf/article/details/8569813
class EvilTransform
  VERSION = '0.0.1'

  PI = 3.14159265358979324
  A  = 6378245.0
  EE = 0.00669342162296594323

  BAIDU_PI = 3.14159265358979324 * 3000.0 / 180.0

  # @example
  #   EvilTransform.new(lat: 39.909745000000, lon: 116.359496000000)
  #   EvilTransform.new(39.909745000000, 116.359496000000)
  #   EvilTransform.new([39.909745000000, 116.359496000000])
  def initialize(*coordinates)
    coordinates = coordinates.flatten
    if coordinates.last.is_a?(Hash)
      @lat, @lon = coordinates.last.values_at(:lat, :lon)
    else
      @lat, @lon = coordinates
    end
    calculation
  end

  # World Geodetic System ==> Mars Geodetic System
  # @example Usage
  #   EvilTransform.new(lat: 39.909745000000, lon: 116.359496000000).to_MGS
  #   # => [39.911112866392486, 116.36569790916941]
  def to_MGS
    if out_of_china?
      [@lat, @lon]
    else
      [@lat + @d_lat, @lon + @d_lon]
    end
  end

  # Mars Geodetic System ==> World Geodetic System
  def to_WGS
    [@lat - @d_lat, @lon - @d_lon]
  end

  # Mars Geodetic System ==> Baidu Geodetic System
  def to_BGS
    z     = Math.sqrt(@lon * @lon + @lat * @lat) + 0.00002 * Math.sin(@lat * BAIDU_PI)
    theta = Math.atan2(@lat, @lon) + 0.000003 * Math.cos(@lon * BAIDU_PI)
    [z * Math.sin(theta) + 0.006, z * Math.cos(theta) + 0.0065]
  end

  # Baidu Geodetic System ==> Mars Geodetic System
  def bgs_to_MGS
    x     = @lon - 0.0065; y = @lat - 0.006
    z     = Math.sqrt(x * x + y * y) - 0.00002 * Math.sin(y * BAIDU_PI)
    theta = Math.atan2(y, x) - 0.000003 * Math.cos(x * BAIDU_PI)
    [z * Math.sin(theta), z * Math.cos(theta)]
  end

  def out_of_china?
    @lon < 72.004 || @lon > 137.8347 || @lat < 0.8293 || @lat > 55.8271
  end

  protected

  def transform_lat
    x    = @lon - 105.0; y = @lat - 35.0
    ret  = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * Math.sqrt(x.abs)
    ret += (20.0  * Math.sin(6.0 * x * PI) + 20.0 * Math.sin(2.0 * x * PI)) * 2.0 / 3.0
    ret += (20.0  * Math.sin(y * PI) + 40.0 * Math.sin(y / 3.0 * PI)) * 2.0 / 3.0
    ret += (160.0 * Math.sin(y / 12.0 * PI) + 320 * Math.sin(y * PI / 30.0)) * 2.0 / 3.0
  end

  def transform_lon
    x = @lon - 105.0; y = @lat - 35.0
    ret  = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * Math.sqrt(x.abs)
    ret += (20.0  * Math.sin(6.0 * x * PI) + 20.0 * Math.sin(2.0 * x * PI)) * 2.0 / 3.0;
    ret += (20.0  * Math.sin(x * PI) + 40.0 * Math.sin(x / 3.0 * PI)) * 2.0 / 3.0;
    ret += (150.0 * Math.sin(x / 12.0 * PI) + 300.0 * Math.sin(x / 30.0 * PI)) * 2.0 / 3.0;
  end

  def calculation
    rad_lat = @lat / 180.0 * PI
    magic   = Math.sin(rad_lat)
    magic   = 1 - EE * magic * magic
    sqrt_magic = Math.sqrt(magic)
    @d_lat = (transform_lat * 180.0) / ((A * (1 - EE)) / (magic * sqrt_magic) * PI)
    @d_lon = (transform_lon * 180.0) / (A / sqrt_magic * Math.cos(rad_lat) * PI)
  end

  class << self
    # @example Usage
    #   EvilTransform.to_MGS(lat: 39.909745000000, lon: 116.359496000000)
    #   # => [39.911112866392486, 116.36569790916941]
    [:to_MGS, :to_WGS, :to_BGS, :bgs_to_MGS].each do |m|
      class_eval <<-CODE
        def #{m}(*coordinates)
          self.new(coordinates).#{m}
        end
      CODE
    end
  end # End of class << self

end
