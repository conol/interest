require "active_record"
require "interest"

class Stuff < ActiveRecord::Base
  acts_as_followee
end
