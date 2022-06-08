module Imagemagick
  def convert(image_file, crop=nil)
    crop &&= "-crop #{crop[:width]}x#{crop[:hight]}+#{crop[:geo_x]}+#{crop[:geo_y]}"
    open("|convert #{image_file} #{crop} txt:", 'r')
  end

  def to_color_code
    convert(self).extract_color_code
  end

  def extract_color_code
    map.with_index do |pixel_info, index|
      index.zero? && next
      coord, rgb, color_code, color_name = pixel_info.delete(':()#').split("\s")
      color_code
    end
  end

  def image_geometry
    w, h = `identify -format "%[width],%[height]" #{self}`.split(',').map(&:to_i)
    {width: w, height: h}
  end
end

include Imagemagick

def full_scan(image_file)
  pp image_file.to_color_code
end

image_file = './test/67417700_p0_30p.jpg'

full_scan(image_file)
