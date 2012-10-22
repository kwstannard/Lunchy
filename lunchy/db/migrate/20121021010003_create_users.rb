class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :favorite_spot_id

      t.timestamps
    end
  end
end
