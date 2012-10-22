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
#    Math.log( 100*(1 + Time.now.day - spot.last_went.day), 1.1).to_int
(1 + Time.now - spot.last_went)
  end
end
