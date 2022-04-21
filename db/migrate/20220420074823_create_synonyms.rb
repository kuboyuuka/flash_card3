class CreateSynonyms < ActiveRecord::Migration[7.0]
  def change
    create_table :synonyms do |t|
      t.string :synonym
      t.integer :post_id

      t.timestamps
    end
  end
end
