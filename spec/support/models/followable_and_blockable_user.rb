require "active_record"
require "interest"

class FollowableAndBlockableUser < ActiveRecord::Base
  self.table_name = :users

  acts_as_followable
  acts_as_blockable
end
