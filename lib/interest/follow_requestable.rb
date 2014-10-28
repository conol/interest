require "interest/follow_requestable/exceptions"
require "interest/follow_requestable/follow_requester"
require "interest/follow_requestable/follow_requestee"
require "interest/follow_requestable/follow_request"

module Interest
  module FollowRequestable
    module Extension
      def acts_as_follow_requester
        include FollowRequester
        define_follow_requester_association_methods
      end

      def acts_as_follow_requestee
        include FollowRequestee
        define_follow_requestee_association_methods
      end

      def acts_as_follow_requestable
        acts_as_follow_requester
        acts_as_follow_requestee
      end
    end
  end
end
