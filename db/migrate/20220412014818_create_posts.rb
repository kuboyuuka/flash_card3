class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.integer :tag_id
      t.string :word
      t.string :mean

      t.timestamps
    end
  end
end
