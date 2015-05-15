class Keyword < ActiveRecord::Base
	has_many :topics, through: :keyword_topics
	has_many :keyword_topics
	has_many :headings
end
