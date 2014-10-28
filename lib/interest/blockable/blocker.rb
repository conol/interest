require "active_support"
require "interest/definition"
require "interest/blockable/exceptions"
require "interest/blockable/blockee"

module Interest
  module Blockable
    module Blocker
      extend ActiveSupport::Concern

      include Interest::Definition.instance_methods_for(:blocker, :blocking)

      def followable?(other)
        if other.is_a?(Interest::Blockable::Blocker)
          super and not other.blocking? self
        else
          super
        end
      end

      def blocking?(blockee)
        blocker_association_method_for(blockee).include? blockee
      end

      def block(blockee)
        return nil if self == blockee or not blockable?(blockee)

        transaction do
          blocker_association_method_for(blockee) << blockee

          if follower? or followee?
            blockee.unfollow self if blockee.follower?
            unfollow blockee if follower?
          end

          if follow_requester? or follow_requestee?
            blockee.cancel_request_to_follow self if blockee.follow_requester?
            cancel_request_to_follow blockee if follow_requester?
          end
        end
      end

      def block!(blockee)
        block blockee or raise Interest::Blockable::Rejected
      end

      def unblock(blockee)
        blocker_association_method_for(blockee).delete blockee
      end

      module ClassMethods
        include Interest::Definition.class_methods_for(:blocker, :blocking)

        def define_blocker_association_methods(*args)
          has_many :blocking_relationships,
            -> { uniq },
            as:          :blocker,
            dependent:   :destroy,
            class_name:  "Blocking"
        end

        def define_blocker_association_method(source_type)
          association_method_name = blocker_association_method_name_for source_type

          has_many association_method_name,
            -> { uniq },
            through:     :blocking_relationships,
            source:      :blockee,
            source_type: source_type
        end
      end
    end
  end
end
