class Topic < ActiveRecord::Base
  has_many :keywords, through: :keyword_topics
  has_many :keyword_topics
  has_many :industries, through: :topic_industries
  has_many :topic_industries
  has_many :metas
end
