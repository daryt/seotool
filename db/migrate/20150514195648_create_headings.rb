class CreateHeadings < ActiveRecord::Migration
  def change
    create_table :headings do |t|
      t.string :heading
      t.references :keyword, index: true

      t.timestamps
    end
  end
end