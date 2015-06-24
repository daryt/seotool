class City < ActiveRecord::Base
  belongs_to :state
  validates :name, uniqueness: { scope: :state_id, message: " already taken for this state - city Name field" }
  before_validation :squish

  def squish
	self.name = self.name.squish.titleize
  end

end
