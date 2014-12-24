class Line < ActiveRecord::Base
  validates :profile_id, :presence => true
  validates :data, :presence => true
  belongs_to :profile
end
