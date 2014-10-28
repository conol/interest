require "active_support"

module Interest
  module FollowRequestable
    module FollowRequest
      extend ActiveSupport::Concern

      included do
        belongs_to :requester, polymorphic: true
        belongs_to :requestee, polymorphic: true

        validates :requester, presence: true
        validates :requestee, presence: true
      end

      def accept
        requester.follow(requestee) and destroy
      end

      def accept!
        requester.follow!(requestee) and destroy
      end

      def accept_mutual_follow
        transaction do
          requester.follow(requestee) and requestee.follow(requester) and destroy
        end
      end

      def accept_mutual_follow!
        transaction do
          requester.follow!(requestee) and requestee.follow!(requester) and destroy
        end
      end

      def reject
        destroy
      end

      alias_method :reject!, :reject
    end
  end
end
