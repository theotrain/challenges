
class Sieve
  attr_reader :max

  def initialize(max)
    @max = max
  end

  def primes
    candidates = (0..max).map{|v| "unmarked"}
    while candidates[2..max].include?("unmarked") do
      unmarked_index = candidates[2..max].index("unmarked") + 2
      candidates[unmarked_index] = unmarked_index
      candidates.map!.with_index{|val, idx| val == "unmarked" && idx%unmarked_index == 0 ? "composite" : val}
    end
    candidates.reject{|val| val.is_a?(String)}
 end

end