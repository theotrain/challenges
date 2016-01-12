class Series
  def initialize (digits)
    @digits = digits
  end

  def slices(slice_length)
    raise ArgumentError if (slice_length > @digits.length)
    slices_array = []
    @digits.each_char.with_index do |d, i|
      last_usable_index = @digits.length - slice_length
      if (i <= last_usable_index)
        slices_array << @digits[i..(i+slice_length-1)].split('').map{|n| n.to_i}
      else
        break
      end
    end
    return slices_array
  end

end