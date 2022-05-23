class AddDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :car, :integer
  end
end
