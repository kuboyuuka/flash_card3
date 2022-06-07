class CreatePostBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :post_books do |t|
      t.integer :post_id
      t.integer :workbook_id
      t.timestamps
    end
  end
end
