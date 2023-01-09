class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :first_name, null: false
      t.string :last_name
      t.string :email, null: false
      t.string :stripe_id
      t.boolean :is_public, null: false, default: true
      t.integer :role, default: 0

      t.timestamps
    end
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end
