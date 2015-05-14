class AddStatusToTemplate < ActiveRecord::Migration
  def change
    add_column :templates, :status, :string
  end
end
