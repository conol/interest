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

      def accept_mutual_follow
        transaction do
          accept and followee.follow(follower)
        end
      end

      def accept_mutual_follow!
        transaction do
          accept! and followee.follow!(follower)
        end
      end

      def reject
        destroy
      end

      alias_method :reject!, :reject
    end
  end
end
