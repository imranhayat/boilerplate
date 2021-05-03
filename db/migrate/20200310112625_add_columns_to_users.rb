class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :stripe_customer_id, :string
    add_column :users, :stripe_payment_method_id, :string
    add_column :users, :payment_status, :boolean, default: false
  end
end
