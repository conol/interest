require "active_record"
require "interest"

class BlockableUser < ActiveRecord::Base
  self.table_name = :users

  acts_as_blocker
  acts_as_blockee
end
