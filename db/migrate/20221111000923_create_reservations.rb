class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.references :gymhouse, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :checkin_date
      t.date :checkout_date

      t.timestamps
    end
  end
end
