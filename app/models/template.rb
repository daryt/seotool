class Template < ActiveRecord::Base
	has_many :pages, through: :page_templates
	has_many :page_templates
  	belongs_to :customer
  	validates :name, uniqueness: { scope: :customer_id, message: " already taken for this customer - template Name field" }

  	before_validation :squish

    def squish
	  self.name = self.name.squish.titleize
    end
end
