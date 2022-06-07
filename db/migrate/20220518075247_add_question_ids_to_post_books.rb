class AddQuestionIdsToPostBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :post_books, :question_id, :integer
  end
end
