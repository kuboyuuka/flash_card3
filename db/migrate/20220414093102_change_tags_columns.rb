class ChangeTagsColumns < ActiveRecord::Migration[7.0]
  def change
    add_column :tags, :name, :string
    remove_column :tags, :tag, :tag_id
  end
end
