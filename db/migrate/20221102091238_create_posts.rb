class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.bigint :user_id, null: false
      t.bigint :thread_id
      t.references :postable, polymorphic: true, null: false

      t.timestamps
    end
    add_foreign_key :posts, :users, column: :user_id
    add_foreign_key :posts, :posts, column: :thread_id
  end
end
