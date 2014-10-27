require "active_support"
require "interest/followable"
require "interest/blockable"

module Interest
  module Base
    extend ActiveSupport::Concern

    def followable?(other)
      is_a?(Interest::Followable::Follower) and other.is_a?(Interest::Followable::Followee)
    end

    def blockable?(other)
      is_a?(Interest::Blockable::Blocker) and other.is_a?(Interest::Blockable::Blockee)
    end

    module ClassMethods
    end
  end
end
