class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.references :product, foreign_key: true
      t.string :nickname
      t.decimal :amount_decimal, precision: 20, scale: 12
      t.string :currency
      t.string :interval
      t.integer :interval_count
      t.string :stripe_id
      t.string :paypal_id
      
      t.timestamps
    end
  end
end
