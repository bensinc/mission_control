class Spot < ActiveRecord::Base
  # attr_accessible :title, :body
  validates_uniqueness_of :message_id
end
