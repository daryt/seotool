class AddIndustryIdToTemplate < ActiveRecord::Migration
  def change
    add_column :templates, :industry_id, :integer
  end
end
