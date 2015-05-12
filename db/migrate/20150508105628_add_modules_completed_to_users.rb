class AddModulesCompletedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :modules_completed, :integer
  end
end
