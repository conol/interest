require "interest/followable/exceptions"
require "interest/followable/following"
require "interest/followable/follower"
require "interest/followable/followee"

module Interest
  module Followable
    module Extension
      def acts_as_follower
        include Follower
        define_follower_association_methods
      end

      def acts_as_followee
        include Followee
        define_followee_association_methods
      end

      def acts_as_followable
        acts_as_follower
        acts_as_followee
      end
    end
  end
end
