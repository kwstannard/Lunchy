class SpotPicker
  def self.pick(spots, users)
    value_buckets = Hash.new
    highest_value = -Float::INFINITY
    spots.each do |spot|
      value = val(spot, users)
      (value_buckets[value] ||= []).push(spot)
      highest_value = value if value > highest_value
    end
    value_buckets[highest_value].sample
  end

  def self.val(spot, users)
    val = Math.log(1 + (Time.now.to_i - spot.last_went.to_i) / 86400, 1.25).to_int
    val + users.select{|u| u.favorite_spot == spot}.count * 2
  end
end
