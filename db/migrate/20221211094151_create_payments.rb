class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :reservation, null: false, foreign_key: true
      t.string :stripe_id

      t.timestamps
    end
    add_monetize :payments, :subtotal, amount: { null: true, default: nil }, currency: { null: true, default: nil }
    add_monetize :payments, :extra_fee, amount: { null: true, default: nil }, currency: { null: true, default: nil }
    add_monetize :payments, :service_fee, amount: { null: true, default: nil }, currency: { null: true, default: nil }
    add_monetize :payments, :total, amount: { null: true, default: nil }, currency: { null: true, default: nil }
  end
end
