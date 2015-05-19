class AddDefaultValueToTemplate < ActiveRecord::Migration
  def self.up
    change_column :templates, :status, :string, default: "draft"
  end
end
