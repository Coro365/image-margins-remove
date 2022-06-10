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

include Imagemagick

def full_scan(image_file)
  pp image_file.to_color_code
end

def horizon_strip_detect(image_file)
  img_geo = image_file.image_geometry
  scan_bandwidth_num = (img_geo[:height] * SCAN_BANDWIDTH_PERCENT * 0.01).to_i

  range_top = (1..scan_bandwidth_num)
  top = borderline(image_file, range_top)

  range_bottom = (img_geo[:height]-1..img_geo[:height]-scan_bandwidth_num)
  bottom = borderline(image_file, range_bottom)

  {top: top + OFFSET_LINE_NUM, bottom: bottom - OFFSET_LINE_NUM}
end

def borderline(image_file, range)
  # TODO: refactoring
  if range.first < range.last
    range.each do |line_num|
      result = color_num_threshold_cheack(image_file, line_num)
      break result if result
    end
  else
    (range.first).downto(range.last) do |line_num|
      result = color_num_threshold_cheack(image_file, line_num)
      break result if result
    end
  end
end

def color_num_threshold_cheack(image_file, line_num)
  color_num = line_colors(image_file, line_num).size
  COLOR_NUM_THRESHOLD < color_num ? line_num : false
end

def line_colors(image_file, line_num)
  crop = {width: 0, height: 1, geo_x: 0, geo_y: line_num}
  colors = image_file.to_color_code(crop)

  colors.sort.uniq.map do |color|
    {code: color, count: colors.count(color)}
  end.sort_by{ |h| h.values_at(:count) }.reverse
end


COLOR_NUM_THRESHOLD = 50
OFFSET_LINE_NUM = 1
SCAN_BANDWIDTH_PERCENT = 30
