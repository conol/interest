require "interest/version"
require "interest/base"
require "interest/followable"
require "interest/follow_requestable"
require "interest/blockable"
require "active_support"
require "active_record"

module Interest
  module Modules
    extend ActiveSupport::Concern

    included do
      include Base
      include Followable
      include FollowRequestable
      include Blockable
    end
  end
end

ActiveRecord::Base.__send__ :include, Interest::Modules
