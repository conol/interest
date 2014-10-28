require "active_record"
require "interest"

class FollowableUser < ActiveRecord::Base
  self.table_name = :users

  acts_as_followable
end
