class AddCusomerIDtoTemplate < ActiveRecord::Migration
  def change
    add_reference :templates, :customer, index: true
  end
end
