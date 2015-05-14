class CreatePageTemplates < ActiveRecord::Migration
  def change
    create_table :page_templates do |t|
      t.references :template, index: true
      t.references :page, index: true

      t.timestamps
    end
  end
end
