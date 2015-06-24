class State < ActiveRecord::Base
	has_many :cities

	validates :name, uniqueness: { message: " already taken - state Name field" }

	  before_validation :squish

	  def squish
		self.name = self.name.squish.titleize
	  end
end
