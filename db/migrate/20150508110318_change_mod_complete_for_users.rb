class ChangeModCompleteForUsers < ActiveRecord::Migration
  def change
  	change_column :users, :modules_completed, :integer, :default => 0
  end
end
