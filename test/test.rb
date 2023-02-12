require 'test/unit'

require_relative '../image-margins-remove.rb'
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
    image_file = './test/5546529697_bg_500.png'
    assert_equal({:width=>500, :height=>374}, image_file.image_geometry)
  end

  def test_color_num_threshold_cheack
    image_file = './test/5546529697_bg_500.png'
    line_num = 100
    axis = 'y'

    assert_equal(line_num, color_num_threshold_cheack(image_file, line_num, axis))
    assert_false(color_num_threshold_cheack(image_file, 0, axis))
  end

  def test_horizon_strip_detect
    image_file = './test/5546529697_bg_500.png'
    assert_equal({:top=>32, :bottom=>341}, horizon_strip_detect(image_file))
  end

  def test_vertical_strip_detect
    image_file = './test/8978741478_bg_500.png'
    assert_equal({:right=>90, :left=>385}, vertical_strip_detect(image_file))
  end

  def test_background_detect
    image_file = './test/5546529697_bg_500.png'
    result = {:top=>32, :bottom=>341, :right=>2, :left=>498}
    assert_equal(result, background_detect(image_file))
  end
end
