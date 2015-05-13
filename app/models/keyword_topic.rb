class KeywordTopic < ActiveRecord::Base
  belongs_to :topic
  belongs_to :keyword
end
