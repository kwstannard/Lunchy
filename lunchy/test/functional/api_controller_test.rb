require 'test_helper'

class ApiControllerTest < ActionController::TestCase

  def setup
    post :add_spot, name: 'dlferp'
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

  test "#pick_spot" do
    get :pick_spot
    assert_equal @response.body, Spot.first.to_json
  end

  test "#add_user" do
    name = "derps"
    assert_difference 'User.count' do
      post :add_user, name: name
    end
    assert_equal name, User.last.name
    assert_equal 201, @response.status
  end

  test "#add_user empty name" do
    assert_difference 'User.count', 0 do
      post :add_user, name: ''
    end
    assert_equal 409, @response.status
  end

  test "#add_user duplicate name" do
    assert_difference 'User.count', 0 do
      post :add_user, name: User.last.name
    end
    assert_equal 409, @response.status
  end

end
