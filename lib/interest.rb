require "interest/version"
require "interest/base"
require "interest/followable"
require "interest/follow_requestable"
require "interest/blockable"
require "active_support"
require "active_record"

module Interest
  module Extension
    extend ActiveSupport::Concern

    included do
      include Base
      extend Followable::Extension
      extend FollowRequestable::Extension
      extend Blockable::Extension
    end

    module ClassMethods
      def interest
        acts_as_followable
        acts_as_follow_requestable
        acts_as_blockable
      end
    end
  end
end

ActiveRecord::Base.__send__ :include, Interest::Extension
