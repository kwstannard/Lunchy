class Spot < ActiveRecord::Base
  attr_accessible :last_went, :name

  validates_uniqueness_of :name
  validates_length_of :name, within: 4..100

  has_many :fans, class_name: "User", foreign_key: :favorite_spot_id

  def as_json(overrides={})
    options = {
      only: [:name, :last_went]
    }.merge overrides
    super(options)
  end
end
