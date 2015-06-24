class Heading < ActiveRecord::Base
  belongs_to :keyword

  validates :heading, presence: true
	  before_validation :squish

	  def squish
		self.heading = self.heading.squish.titleize
	  end
end
