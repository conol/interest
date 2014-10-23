require "active_support"
require "interest/followable/follower"
require "interest/followable/followee"

module Interest
  module Followable
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_follower
        include Follower
      end

      def acts_as_followee
        include Followee
      end
    end
  end
end
