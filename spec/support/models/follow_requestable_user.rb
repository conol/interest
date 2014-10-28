require "active_record"
require "interest"

class FollowRequestableUser < ActiveRecord::Base
  self.table_name = :users

  acts_as_follower
  acts_as_followee
  acts_as_follow_requester
  acts_as_follow_requestee
end
