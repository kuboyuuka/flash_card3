class AddDetailsToWorkBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :workbooks, :judgement, :string
    add_column :workbooks, :score, :integer
  end
end
