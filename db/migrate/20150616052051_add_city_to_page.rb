class AddCityToPage < ActiveRecord::Migration
  def change
    add_column :pages, :city, :string
    add_column :pages, :state, :string
  end
end
