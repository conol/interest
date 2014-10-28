require "active_support"
require "interest/followable"
require "interest/follow_requestable"
require "interest/blockable"

module Interest
  module Base
    extend ActiveSupport::Concern

    def followable?(other)
      is_a?(Interest::Followable::Follower) and other.is_a?(Interest::Followable::Followee)
    end

    def follow_requestable?(other)
      followable?(other) and is_a?(Interest::FollowRequestable::FollowRequester) and other.is_a?(Interest::FollowRequestable::FollowRequestee)
    end

    def blockable?(other)
      is_a?(Interest::Blockable::Blocker) and other.is_a?(Interest::Blockable::Blockee)
    end

    def follower?
      is_a? Interest::Followable::Follower
    end

    def followee?
      is_a? Interest::Followable::Followee
    end

    def follow_requester?
      is_a? Interest::FollowRequestable::FollowRequester
    end

    def follow_requestee?
      is_a? Interest::FollowRequestable::FollowRequestee
    end

    def blocker?
      is_a? Interest::Blockable::Blocker
    end

    def blockee?
      is_a? Interest::Blockable::Blockee
    end

    module ClassMethods
    end
  end
end
