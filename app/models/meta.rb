class Meta < ActiveRecord::Base
  belongs_to :topic

  validates :description, presence: true
  before_validation :squish

  def squish
	self.description = self.description.squish
  end
end
