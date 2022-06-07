class CreatePostForms < ActiveRecord::Migration[7.0]
  def change
    create_table :post_forms do |t|

      t.timestamps
    end
  end
end
