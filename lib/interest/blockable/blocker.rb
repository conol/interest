require "active_support"
require "active_record"
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
        return nil unless valid_blocking_for?(blockee)

        transaction do
          blockee.unfollow self if blockee.follower?
          unfollow blockee if follower?
          blockee.cancel_request_to_follow self if blockee.follow_requester?
          cancel_request_to_follow blockee if follow_requester?

          collection = blocker_association_method_for blockee

          begin
            collection << blockee
          rescue ActiveRecord::RecordNotUnique
            collection
          end
        end
      end

      def block!(blockee)
        block blockee or raise Interest::Blockable::Rejected
      end

      def unblock(blockee)
        blocker_association_method_for(blockee).delete blockee
      end

      def valid_blocking_for?(blockee)
        not (self == blockee or not blockable?(blockee))
      end

      module ClassMethods
        include Interest::Definition.class_methods_for(:blocker, :blocking)

        def define_blocker_association_methods
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
