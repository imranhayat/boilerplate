class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true
      t.references :plan, foreign_key: true
      t.string :stripe_id
      t.bigint :current_period_start
      t.bigint :current_period_end
      t.boolean :cancel_at_period_end
      t.boolean :active, default: false
      
      t.timestamps
    end
  end
end
