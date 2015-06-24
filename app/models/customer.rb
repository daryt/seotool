class Customer < ActiveRecord::Base
  has_many :templates

  validates :name, uniqueness: { scope: :state_id, message: " already taken for this state - city Name field" }
  before_validation :squish

  def squish
	self.name = self.name.squish.titleize
  end

end
