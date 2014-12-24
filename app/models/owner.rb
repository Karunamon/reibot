class Owner < ActiveRecord::Base
  validates :name, :presence => true
  validates :name, :uniqueness => true
  has_many :profiles
  serialize :privileges
end