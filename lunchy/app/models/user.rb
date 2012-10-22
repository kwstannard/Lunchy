class User < ActiveRecord::Base
  attr_accessible :name, :favorite_spot
  belongs_to :favorite_spot, class_name: "Spot", foreign_key: :favorite_spot_id

  def as_json(overrides = {})
    options = {
      only: [:name]
    }.merge overrides
    super(options)
  end
end
