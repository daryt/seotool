class AddAbbrevToStates < ActiveRecord::Migration
  def change
    add_column :states, :abbrev, :string
  end
end
