class CreateKeywordTopics < ActiveRecord::Migration
  def change
    create_table :keyword_topics do |t|
      t.references :topic, index: true
      t.references :keyword, index: true

      t.timestamps
    end
  end
end
