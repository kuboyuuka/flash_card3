class AddNullTrue < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:users, :score, true)
    change_column_null(:users, :car, true)
    change_column_null(:users, :rank, true)
  end
end
