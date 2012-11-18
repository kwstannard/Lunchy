require 'random_spot_picker'
class ApiController < ApplicationController
  def add_spot
    Spot.create! name: params['name']
    render json: nil, status: 201
  end

  def edit_spot
    Spot.where(name: params['name_old']).first!.update_attributes!(
      name: params['name_new']
    )
  end

  def remove_spot
    Spot.where(name: params['name']).each &:destroy
  end

  def pick_spot
    users = User.where(name: params['user_names'].split(","))
    spot = SpotPicker.pick(Spot.all, users)
    last_went = spot.last_went
    spot.update_attributes! last_went: Time.now
    render json: { name: spot.name, last_went: last_went }
  end

  def list_spots
    render json: Spot.all
  end

  def set_favorite
    User.create name: params['user_name']
    user = User.where(name: params['user_name']).first
    spot = Spot.where(name: params['spot_name']).first!
    user.update_attributes! favorite_spot: spot
    render json: nil, status: 200
  end

  rescue_from ActiveRecord::ActiveRecordError do |ex|
    logger.error("api error: #{ex}")
    error = {
      :code        => 409,
      :name        => ex.class,
      :description => ex.message
    }
    render json: error, status: 409
  end
end
