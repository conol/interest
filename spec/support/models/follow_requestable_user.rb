require "active_record"
require "interest"

class FollowRequestableUser < ActiveRecord::Base
  self.table_name = :users

  acts_as_followable
  acts_as_follow_requestable
end
