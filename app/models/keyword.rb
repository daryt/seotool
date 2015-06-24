class Keyword < ActiveRecord::Base
	has_many :topics, through: :keyword_topics
	has_many :keyword_topics
	has_many :headings

	validates :keyword, presence: true
    before_validation :squish

    def squish
	  self.keyword = self.keyword.squish.titleize
    end

end
