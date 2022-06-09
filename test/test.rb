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
end
