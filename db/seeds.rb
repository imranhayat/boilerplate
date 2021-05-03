[User].each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE #{table.table_name} RESTART IDENTITY CASCADE")
end
Role.create([{ name: :admin }, { name: :normal }])
User.create([{ first_name: 'Main', last_name: 'Admin', email: 'admin@test.com', password: 'admin123', role_ids: '1' }, {first_name: 'Saqib', last_name: 'Shahzad', email: 'user@test.com', password: 'admin123', role_ids: '2' } ])