class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :topic_id
      t.integer :k1_id
      t.integer :k2_id
      t.integer :k3_id
      t.integer :h1_id
      t.integer :h2_id
      t.integer :h3_id
      t.integer :meta_id

      t.timestamps
    end
  end
end
