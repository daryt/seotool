class Removecityandstatefrompages < ActiveRecord::Migration
  def change
  	remove_column :pages, :state, :string
  	remove_column :pages, :city, :string
  end
end
