require "interest/version"
require "interest/base"
require "interest/followable"
require "interest/blockable"
require "active_record"

module Interest
end

ActiveRecord::Base.__send__ :include, Interest::Base
ActiveRecord::Base.__send__ :include, Interest::Followable
ActiveRecord::Base.__send__ :include, Interest::Blockable
