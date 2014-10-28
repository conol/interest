require "active_support"
require "interest/followable/exceptions"
require "interest/followable/following"
require "interest/followable/follower"
require "interest/followable/followee"

module Interest
  module Followable
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_follower(*args)
        include Follower
        define_follower_association_methods *args
      end

      def acts_as_followee(*args)
        include Followee
        define_followee_association_methods *args
      end

      def acts_as_followable
        acts_as_follower
        acts_as_followee
      end
    end
  end
end
