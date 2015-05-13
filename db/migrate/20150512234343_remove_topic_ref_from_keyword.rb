class RemoveTopicRefFromKeyword < ActiveRecord::Migration
  def change
    remove_reference :keywords, :topics, index: true
  end
end
