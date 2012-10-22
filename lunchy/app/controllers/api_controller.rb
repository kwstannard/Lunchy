require 'random_spot_picker'
class ApiController < ApplicationController
  def add
    Spot.create! name: params['name']
    render json: nil, status: 201
  end

  def edit
    Spot.where(name: params['name_old']).first.update_attributes!(
      name: params['name_new']
    )
  end

  def remove
    Spot.where(name: params['name']).each &:destroy
  end

  def list_spots
    render json: Spot.all
  end

  def filter
    render json: 'implement filter'
  end

  def list_filters
    render json: 'implement list_filters'
  end

  def pick_spot
    spot = RandomSpotPicker.pick(Spot.all)
    spot.update_attributes last_went: Time.now
    render json: spot
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
