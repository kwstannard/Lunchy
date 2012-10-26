require 'test_helper'

class ApiControllerTest < ActionController::TestCase

  def setup
    Spot.create name: 'dlferp', last_went: Time.now - 86400
  end

  test "#add_spot success" do
    name = 'herp'
    assert_difference 'Spot.count' do
      post :add_spot, name: name
    end
    assert_equal name, Spot.last.name
    assert_equal 201, @response.status
  end

  test "#add_spot empty name" do
    assert_difference 'Spot.count', 0 do
      post :add_spot, name: ''
    end
    assert_equal 409, @response.status
  end

  test "#add_spot duplicate name" do
    assert_difference 'Spot.count', 0 do
      post :add_spot, name: Spot.last.name
    end
    assert_equal 409, @response.status
  end

  test "#remove_spot" do
    name = Spot.first.name
    post :remove_spot, name: name
    assert_equal 0, Spot.where(name: name).count
  end

  test "#edit_spot" do
    name = Spot.first.name
    name_new = 'herp'
    post :edit_spot, name_old: name, name_new: name_new
    assert_equal name_new, Spot.first.name
  end

  test "#list_spots" do
    spots = [*Spot.all, Spot.create(name:'herp'), Spot.create(name:'derp')]
    get :list_spots
    assert_equal spots.to_json, @response.body
  end

  test "#pick_spot successful" do
    spot = Spot.create name: 'double', last_went: Time.now
    2.times {|i| User.create name: "user#{i}", favorite_spot: spot }
    user_names = User.pluck :name
    get :pick_spot, user_names: user_names
    assert_equal @response.body, Spot.where(name: 'double').first.to_json
  end

  test "#set_favorite" do
    spot_name = Spot.first.name
    user_name = User.first.name
    assert_difference 'Spot.first.fans.count', 1 do
      post :set_favorite, spot_name: spot_name, user_name: user_name
    end
  end

  test "#set_favorite no spot found" do
    post :set_favorite, spot_name: 'fake_name', user_name: 'double'
    assert_equal 409, @response.status
  end
end
