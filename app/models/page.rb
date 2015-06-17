class Page < ActiveRecord::Base
	has_one :template, through: :page_template
	has_one :page_template

	def self.to_csv(options = {})
	  CSV.generate(options) do |csv|
	    csv << column_names
	    all.each do |page|
	      csv << page.attributes.values_at(*column_names)
	    end
	  end
	end
end
