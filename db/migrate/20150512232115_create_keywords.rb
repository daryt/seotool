class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string :keyword
      t.integer :count
      t.references :topics, index: true

      t.timestamps
    end
  end
end
