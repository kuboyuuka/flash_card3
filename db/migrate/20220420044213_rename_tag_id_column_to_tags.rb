class RenameTagIdColumnToTags < ActiveRecord::Migration[7.0]
  def change
    rename_column :tags, :tag_id, :post_id
  end
end
