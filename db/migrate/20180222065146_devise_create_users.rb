class DeviseCreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      
    end

    add_index :users, :email,                unique: true
    add_index :users, :revoke_access
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
