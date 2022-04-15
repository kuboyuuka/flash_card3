class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :word
      t.string :mean
      t.integer :user_id, :tag_id

      t.timestamps
    end
  end
end
