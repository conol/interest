class Following < ActiveRecord::Base
  belongs_to :follower, polymorphic: true
  belongs_to :followee, polymorphic: true

  validates :follower, presence: true
  validates :followee, presence: true
end
