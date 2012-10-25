class SpotPicker
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
    val = Math.log(1 + Time.now.to_i - spot.last_went.to_i, 2).to_int
    val + spot.fans.count * 16
  end
end
