class CreateOptions < ActiveRecord::Migration[7.0]
  def change
      change_column_null(:post_tags, :tag_id, true)
  end
end
