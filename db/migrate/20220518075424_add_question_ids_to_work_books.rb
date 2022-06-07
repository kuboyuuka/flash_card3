class AddQuestionIdsToWorkBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :workbooks, :question_id, :integer
  end
end
