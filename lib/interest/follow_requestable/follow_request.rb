require "active_support"

module Interest
  module FollowRequestable
    module FollowRequest
      extend ActiveSupport::Concern

      def accept
        update status: "accepted"
      end

      def accept!
        update! status: "accepted"
      end

      def mutual
        followee.follow(follower)
      end

      def mutual!
        followee.follow!(follower)
      end

      def accept_mutual_follow
        transaction { accept and mutual }
      end

      def accept_mutual_follow!
        transaction { accept! and mutual! }
      end

      def reject
        destroy
      end

      alias_method :reject!, :reject
    end
  end
end
