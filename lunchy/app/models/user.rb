class User < ActiveRecord::Base
  attr_accessible :name, :favorite_spot
  belongs_to :favorite_spot,
             class_name: "Spot",
             foreign_key: 'favorite_spot_id'

  validates_uniqueness_of :name
  validates_length_of :name, within: 4..100

  def as_json(overrides = {})
    options = {
      only: [:name]
    }.merge overrides
    super(options)
  end
end
