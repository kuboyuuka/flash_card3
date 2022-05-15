class ChangeDataTypeAnswerOfPostBooks < ActiveRecord::Migration[7.0]
  def change
    change_column :post_books, :answer, :text
  end
end
