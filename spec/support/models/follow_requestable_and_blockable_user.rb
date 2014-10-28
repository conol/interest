require "active_record"
require "interest"

class FollowRequestableAndBlockableUser < ActiveRecord::Base
  self.table_name = :users

  acts_as_follower
  acts_as_followee
  acts_as_follow_requester
  acts_as_follow_requestee
  acts_as_blocker
  acts_as_blockee
end
