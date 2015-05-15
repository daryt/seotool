class Topic < ActiveRecord::Base
  belongs_to :industry
  has_many :keywords, through: :keyword_topics
  has_many :keyword_topics
  has_many :metas
end
