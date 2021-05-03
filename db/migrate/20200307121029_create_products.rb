class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :stripe_id
      t.string :paypal_id
      t.integer :payment_gateway, default: 0
      t.timestamps
    end
  end
end
