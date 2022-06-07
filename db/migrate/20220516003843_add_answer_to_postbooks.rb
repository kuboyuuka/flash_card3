class AddAnswerToPostbooks < ActiveRecord::Migration[7.0]
  def change
    add_column :post_books, :answer, :text
  end
end
