require "active_record"
require "interest"

class User < ActiveRecord::Base
  acts_as_follower "User", "Stuff"
  acts_as_followee
end
