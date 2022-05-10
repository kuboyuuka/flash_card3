class CreateWorkbooks < ActiveRecord::Migration[7.0]
  def change
    create_table :workbooks do |t|
      t.integer :user_id
      t.integer :workbook
      t.timestamps
    end
  end
end
