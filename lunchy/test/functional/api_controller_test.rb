require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "#add success" do
    name = 'herp'
    assert_difference 'Spot.count' do
      post :add, name: name
    end
    assert_equal name, Spot.last.name
    assert_equal 201, @response.status
  end

  test "#add empty name" do
    assert_difference 'Spot.count', 0 do
      post :add, name: ''
    end
    assert_equal 409, @response.status
  end

  test "#add duplicate name" do
    assert_difference 'Spot.count', 0 do
      post :add, name: Spot.last.name
    end
    assert_equal 409, @response.status
  end

  test "#remove" do
    name = Spot.first.name
    post :remove, name: name
    assert_equal 0, Spot.where(name: name).count
  end

  test "#edit" do
    name = Spot.first.name
    name_new = 'herp'
    post :edit, name_old: name, name_new: name_new
    assert_equal name_new, Spot.first.name
  end

  test "#list_spots" do
    spots = [*Spot.all, Spot.create(name:'herp'), Spot.create(name:'derp')]
    get :list_spots
    assert_equal spots.to_json, @response.body
  end

  test "#pick_spot" do
    get :pick_spot
    assert_equal Spot.last.name, @response.body
  end

end
