class AddDefaultValueToKeyword < ActiveRecord::Migration
  def change
  	change_column :keywords, :count, :integer, default: 500
  end
end
