require "active_record"
require "interest"

class FollowableUser < ActiveRecord::Base
  self.table_name = :users

  acts_as_follower
  acts_as_followee
end
