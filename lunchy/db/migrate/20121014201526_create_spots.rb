class CreateSpots < ActiveRecord::Migration
  def change
    create_table :spots do |t|
      t.string :name
      t.datetime :last_went, default: Time.now.to_s

      t.timestamps
    end
  end
end
