class Topic < ActiveRecord::Base
  has_many :keywords, through: :keyword_topics
  has_many :keyword_topics
  has_many :industries, through: :topic_industries
  has_many :topic_industries
  has_many :metas

  validates :name, presence: { message: " required - New Topic Field" }
    before_validation :squish

    def squish
	  self.name = self.name.squish.titleize
    end
end
