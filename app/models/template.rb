class Template < ActiveRecord::Base
	has_many :pages, through: :page_templates
	has_many :page_templates
  belongs_to :customer
end
