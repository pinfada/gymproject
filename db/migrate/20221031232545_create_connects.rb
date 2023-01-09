class CreateConnects < ActiveRecord::Migration[7.0]
  def change
    create_table :connects do |t|
      t.integer :followed_id
      t.integer :follower_id

      t.timestamps
    end
    add_index :connects, :follower_id
    add_index :connects, :followed_id
    add_index :connects, [:follower_id, :followed_id], unique: true

  end
end
