class CreateTopicsIndustries < ActiveRecord::Migration
  def change
  	# remove_reference :topics, :industries, index: true
  	remove_reference :topics, :industry, index: true
    create_table :topic_industries do |t|
    	t.references :industry, index: true
      	t.references :topic, index: true

      	t.timestamps
    end
  end
end
