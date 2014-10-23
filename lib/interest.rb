require "interest/version"
require "interest/followable"
require "active_record"

module Interest
  # Your code goes here...
end

ActiveRecord::Base.__send__ :include, Interest::Followable
