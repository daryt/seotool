class PageTemplate < ActiveRecord::Base
  belongs_to :template
  belongs_to :page
end
