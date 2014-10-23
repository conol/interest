require "active_record"
require "interest"

class Collection < ActiveRecord::Base
  acts_as_follower
  acts_as_followee
end
