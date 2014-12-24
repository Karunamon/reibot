class Profile < ActiveRecord::Base
  has_many :lines, :dependent => :destroy
  belongs_to :owner
end