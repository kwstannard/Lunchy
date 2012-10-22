class RandomSpotPicker
  def self.pick(spots)
    value_buckets = Hash.new
    highest_value = -Float::INFINITY
    spots.each do |spot|
      value = val(spot)
      (value_buckets[value] ||= []).push(spot)
      highest_value = value if value > highest_value
    end
    value_buckets[highest_value].sample
  end

  def self.val(spot)
    Math.log(1 + Time.now.to_i - spot.last_went.to_i, 2).to_int
  end
end
