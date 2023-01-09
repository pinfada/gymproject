class CreateGymhouses < ActiveRecord::Migration[7.0]
  def change
    create_table :gymhouses do |t|
      t.integer :customer_id
      t.integer :prospect_id
      t.string :name, null: false
      t.string :headline, null: false
      t.string :description, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :postal, null: false
      t.string :address1, null: false
      t.string :address2
      t.string :country, null: false
      t.float :latitude
      t.float :longitude
      
      t.timestamps
    end
    add_monetize :gymhouses, :price, amount: { null: true, default: nil }, currency: { null: true, default: nil }
    add_index :gymhouses, [:latitude, :longitude]
  end
end