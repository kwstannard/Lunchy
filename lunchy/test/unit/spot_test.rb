require 'test_helper'

class SpotTest < ActiveSupport::TestCase
  test "#name= capitalizes names" do
    name = "hERP dERP-zurp"
    correct_name = 'Herp Derp-zurp'
    spot = Spot.new name: name
    assert_equal correct_name, spot.name
  end

  test "#find_spot fixes the name and then finds it" do
    name = "hERP dERP-zurp"
    name_weird = "Herp Derp-Zurp"
    spot = Spot.create(name: name)
    assert_equal spot, Spot.find_spot(name_weird)
  end
end
