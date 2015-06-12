class Industry < ActiveRecord::Base
	has_many :topics, through: :topic_industries
  	has_many :topic_industries
end
