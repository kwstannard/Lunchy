require 'test_helper'

class SpotTest < ActiveSupport::TestCase
  test "#name= capitalizes names" do
    name = "hERP dERP-zurp"
    correct_name = 'Herp Derp-zurp'
    spot = Spot.new name: name
    assert_equal correct_name, spot.name
  end
end
