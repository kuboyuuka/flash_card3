class RenameWorkbookColumnToWorkbooks < ActiveRecord::Migration[7.0]
  def change
    rename_column :workbooks, :workbook, :answer
  end
end
