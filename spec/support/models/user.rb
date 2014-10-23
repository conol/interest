require "active_record"
require "interest"

class User < ActiveRecord::Base
  acts_as_follower
  acts_as_followee
end
