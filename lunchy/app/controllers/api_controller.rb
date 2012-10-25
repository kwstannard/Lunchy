require 'random_spot_picker'
class ApiController < ApplicationController
  def add_spot
    Spot.create! name: params['name']
    render json: nil, status: 201
  end

  def edit_spot
    Spot.where(name: params['name_old']).first.update_attributes!(
      name: params['name_new']
    )
  end

  def remove_spot
    Spot.where(name: params['name']).each &:destroy
  end

  def pick_spot
    spot = SpotPicker.pick(Spot.all)
    spot.update_attributes! last_went: Time.now
    render json: spot
  end

  def list_spots
    render json: Spot.all
  end

  def add_user
    User.create! name: params['name']
    render json: nil, status: 201
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
