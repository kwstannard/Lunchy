class CreateSpots < ActiveRecord::Migration
  def change
    create_table :spots do |t|
      t.string :name
      t.time :last_went, default: Time.now

      t.timestamps
    end
  end
end
