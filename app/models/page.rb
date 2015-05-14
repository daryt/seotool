class Page < ActiveRecord::Base
	has_one :template, through: :page_template
	has_one :page_template
end
