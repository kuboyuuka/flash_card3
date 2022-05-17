class RemovePostAnswerFromPostBooks < ActiveRecord::Migration[7.0]
  def change
    remove_column :post_books, :answer, :text
  end
end
