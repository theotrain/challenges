class OCR
                                                                               
  def initialize (text)
    @text = text
    @digits = []
    @digits[0] =[ " _ ",
                  "| |",
                  "|_|",
                  "   "]
    @digits[1] =[ "   ",
                  "  |",
                  "  |",
                  "   "]
    @digits[2] =[ " _ ",
                  " _|",
                  "|_ ",
                  "   "] 
    @digits[3] =[ " _ ",
                  " _|",
                  " _|",
                  "   "]
    @digits[4] =[ "   ",
                  "|_|",
                  "  |",
                  "   "] 
    @digits[5] =[ " _ ",
                  "|_ ",
                  " _|",
                  "   "]
    @digits[6] =[ " _ ",
                  "|_ ",
                  "|_|",
                  "   "] 
    @digits[7] =[ " _ ",
                  "  |",
                  "  |",
                  "   "]
    @digits[8] =[ " _ ",
                  "|_|",
                  "|_|",
                  "   "] 
    @digits[9] =[ " _ ",
                  "|_|",
                  " _|",
                  "   "]  
  end

  def convert
    result = []
    line_groups = convert_to_4_line_groups(@text)
    line_groups.each do |lg|
      result << convert_line_group_to_decimal_string(lg)
    end
    result.join(",")
  end

  def convert_to_4_line_groups(text)
    line_groups = []
    text = text.split("\n")
    text.each_slice(4) {|line| line_groups << line}
    line_groups
  end

  def convert_line_group_to_decimal_string(line_group)
    str = ""
    line_array2d = convert_to_2d_array_of_digits(line_group)
    line_array2d.each do |digit|
      str += convert_to_decimal_value(digit)
    end
    str
  end

  def convert_to_2d_array_of_digits(line_group)
    digits_in_line_group = (line_group[1].length/3.0).ceil
    array2d = Array.new(digits_in_line_group) {Array.new(line_group.length, "   ")}
    line_group.each_with_index do |lg, i| 
      lg.split('').each_slice(3).with_index {|slice, idx| array2d[idx][i] = '%-3.3s' % slice.join}
    end
    array2d
  end

  def convert_to_decimal_value(this_digit)
    this_digit[3] = "   " if this_digit.length < 4
    @digits.each_with_index do |digit, idx|
      return idx.to_s if digit == this_digit
    end
    "?"
  end

end