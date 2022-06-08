require 'bundler/setup'

image_file = './test/67417700_p0_30p.jpg'

def full_scan(image_file)
  f = open("|convert #{image_file} txt:", 'r')
  pp image_color_info_2array(f)
end

def image_color_info_2array(string)
  string.map.with_index do |pixel_info, index|
    index.zero? && next
    coord, rgb, color_code, color_name = pixel_info.delete(':()#').split("\s")
    color_code
  end
end

full_scan(image_file)
