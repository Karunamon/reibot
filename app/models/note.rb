class Note < ActiveRecord::Base
  validates :sender, presence: true
  validates :recipient, presence: true
  validates :text, presence: true
end