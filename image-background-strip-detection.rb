module Imagemagick
  def convert(image_file, crop=nil)
    crop &&= "-crop #{crop[:width]}x#{crop[:height]}+#{crop[:geo_x]}+#{crop[:geo_y]}"
    cmd = ["|convert", image_file, crop, "txt:"].join("\s")
    open(cmd, 'r')
  end

  def to_color_code(crop=nil)
    convert(self, crop).extract_color_code
  end

  def extract_color_code
    map.with_index do |pixel_info, index|
      index.zero? && next
      coord, rgb, color_code, color_name = pixel_info.delete(':()#').split("\s")
      color_code
    end.compact
  end

  def image_geometry
    w, h = `identify -format "%[width],%[height]" #{self}`.split(',').map(&:to_i)
    {width: w, height: h}
  end
end

class Range
  def to_a_semantic_oder
    (self.first < self.last) ? self.to_a : (self.last..self.first).to_a.reverse
  end
end

include Imagemagick

def full_scan(image_file)
  pp image_file.to_color_code
end

def horizon_strip_detect(image_file)
  strip_detect(image_file, 'y')
end

def vertical_strip_detect(image_file)
  strip_detect(image_file, 'x')
end

def strip_detect(image_file, axis)
  img_geo = image_file.image_geometry
  line_length = (axis == 'x') ? img_geo[:width] : img_geo[:height]
  scan_bandwidth_num = (line_length * SCAN_BANDWIDTH_PERCENT * 0.01).to_i

  range_increase = (1..scan_bandwidth_num)
  border_1 = borderline(image_file, range_increase, axis)
  border_1 && border_1 += OFFSET_LINE_NUM

  range_decrease = (line_length - 1..line_length - scan_bandwidth_num)
  border_2 = borderline(image_file, range_decrease, axis)
  border_2 && border_2 -= OFFSET_LINE_NUM

  if axis == 'x'
    return {right: border_1, left: border_2}
  elsif axis == 'y'
    return {top: border_1, bottom: border_2}
  end
end

def borderline(image_file, range, axis)
  range.to_a_semantic_oder.each do |line_num|
    result = color_num_threshold_cheack(image_file, line_num, axis)
    return result if result
  end

  # not detect strip
  return nil
end

def color_num_threshold_cheack(image_file, line_num, axis)
  color_num = line_colors(image_file, line_num, axis).size
  COLOR_NUM_THRESHOLD < color_num ? line_num : false
end

def line_colors(image_file, line_num, axis)
  if axis == 'x'
    crop = {width: 1, height: 0, geo_x: line_num, geo_y: 0}
  elsif axis == 'y'
    crop = {width: 0, height: 1, geo_x: 0, geo_y: line_num}
  end

  colors = image_file.to_color_code(crop)

  colors.sort.uniq.map do |color|
    {code: color, count: colors.count(color)}
  end.sort_by{ |h| h.values_at(:count) }.reverse
end

def background_detect(image_file)
  hor_r = horizon_strip_detect(image_file)
  ver_r = vertical_strip_detect(image_file)
  hor_r.merge(ver_r)
end

def argv
  unless ARGV.empty?
    return background_detect(ARGV.first)
  end
end


COLOR_NUM_THRESHOLD = 50
OFFSET_LINE_NUM = 1
SCAN_BANDWIDTH_PERCENT = 30

p argv
