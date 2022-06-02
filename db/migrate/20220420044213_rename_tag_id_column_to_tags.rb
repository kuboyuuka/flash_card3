class RenameTagIdColumnToTags < ActiveRecord::Migration[7.0]
  def change
    add_column :tags, :post_id, :integer
  end
end
