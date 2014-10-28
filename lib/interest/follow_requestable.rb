require "active_support"
require "interest/follow_requestable/exceptions"
require "interest/follow_requestable/follow_requester"
require "interest/follow_requestable/follow_requestee"
require "interest/follow_requestable/follow_request"

module Interest
  module FollowRequestable
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_follow_requester(*args)
        include FollowRequester
        define_follow_requester_association_methods *args
      end

      def acts_as_follow_requestee(*args)
        include FollowRequestee
        define_follow_requestee_association_methods *args
      end
    end
  end
end
