class CreateMeta < ActiveRecord::Migration
  def change
    create_table :meta do |t|
      t.string :description
      t.references :topic, index: true

      t.timestamps
    end
  end
end
