class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :city
      t.string :state
      t.string :postal
      t.string :address1
      t.string :address2
      t.string :country
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end