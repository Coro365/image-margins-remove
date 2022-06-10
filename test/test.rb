require 'test/unit'

require_relative '../image-background-strip-detection.rb'
include Imagemagick

class TestRubyMyCommon < Test::Unit::TestCase
  def test_extract_color_code
    convert_result = "# ImageMagick pixel enumeration: 614,1,0,255,srgb
                      0,0: (0,0,0)  #000000  black
                      1,0: (0,0,0)  #000000  black
                      2,0: (0,0,0)  #000000  black
                      3,0: (0,0,0)  #000000  black
                      4,0: (0,0,0)  #000000  black
                      5,0: (0,0,0)  #000000  black
                      6,0: (0,0,0)  #000000  black
                      7,0: (0,0,0)  #000000  black
                      8,0: (0,0,0)  #000000  black
                      9,0: (0,0,0)  #000000  black"
    color_code = '000000'

    assert_equal(color_code, convert_result.split("\n").extract_color_code.first)
  end

  def test_image_geometry
    image_file = './test/67417700_p0_30p.jpg'
    assert_equal({:width=>614, :height=>341}, image_file.image_geometry)
  end

  def test_color_num_threshold_cheack
    image_file = './test/67417700_p0_30p.jpg'
    line_num = 100

    assert_equal(line_num, color_num_threshold_cheack(image_file, line_num))
    assert_false(color_num_threshold_cheack(image_file, 0))
  end

  def test_horizon_strip_detect
    image_file = './test/67417700_p0_30p.jpg'
    assert_equal({:top=>43, :bottom=>297}, horizon_strip_detect(image_file))
  end
end
