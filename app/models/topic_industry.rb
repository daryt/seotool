class TopicIndustry < ActiveRecord::Base
  belongs_to :industry
  belongs_to :topic
end
