class Customer < ActiveRecord::Base
  has_many :templates

  validates :name, uniqueness: { message: " already taken for this customer - customer Name field" }, presence: { message: " required - New Customer Field" }
  before_validation :squish

  def squish
	self.name = self.name.squish.titleize
  end

end
