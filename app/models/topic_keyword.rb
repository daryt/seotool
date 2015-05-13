class TopicKeyword < ActiveRecord::Base
  belongs_to :topics
  belongs_to :keywords
end
