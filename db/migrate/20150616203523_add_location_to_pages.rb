class AddLocationToPages < ActiveRecord::Migration
  def change
    add_column :pages, :city_id, :integer
    add_column :pages, :state_id, :integer
  end
end
