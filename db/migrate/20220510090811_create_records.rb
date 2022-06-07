class CreateRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :records do |t|
      t.integer :user_id
      t.integer :workbook_id
      t.integer :score
      t.timestamps
    end
  end
end
