class AddDetailsToPostBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :post_books, :judgment, :string
  end
end
