class Industry < ActiveRecord::Base
	has_many :topics, through: :topic_industries
  	has_many :topic_industries
  	validates :name, presence: { message: " required - New Industry Field" }, uniqueness: { message: " already taken - New Industry field" }

	  before_validation :squish

	  def squish
		self.name = self.name.squish.titleize
	  end
end
