require "active_record"
require "interest"

class FollowRequestableAndBlockableUser < ActiveRecord::Base
  self.table_name = :users

  interest
end
