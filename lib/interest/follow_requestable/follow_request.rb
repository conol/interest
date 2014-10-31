require "active_support"

module Interest
  module FollowRequestable
    module FollowRequest
      extend ActiveSupport::Concern

      included do
        validate :validate_follow_request_relationships, if: :should_validate_follow_request_relationships?
      end

      def accept
        update status: "accepted"
      end

      def accept!
        update! status: "accepted"
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

      def should_validate_follow_request_relationships?
        pending? and follower.is_a?(ActiveRecord::Base) and followee.is_a?(ActiveRecord::Base)
      end

      def validate_follow_request_relationships
        errors.add :follower, :invalid unless follower.follow_requester?
        errors.add :followee, :invalid unless followee.follow_requestee?
        errors.add :followee, :rejected if follower.follow_requester? and not follower.valid_follow_request_for?(followee)
      end
    end
  end
end
