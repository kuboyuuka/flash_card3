class ChangeTagsColumns < ActiveRecord::Migration[7.0]
  def change
    remove_column :tags, :name, :string
    add_column :tags, :tag, :string
  end
end
