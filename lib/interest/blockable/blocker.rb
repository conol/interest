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
        super and not other.blocking?(self)
      end

      def blocking?(blockee)
        blocker_association_method_for(blockee).include? blockee
      end

      def blockable?(blockee)
        blockee.is_a?(Interest::Blockable::Blockee)
      end

      def block(blockee)
        return nil if self == blockee or not blockable?(blockee)
        blocker_association_method_for(blockee) << blockee
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
          has_many :blockings,
            -> { uniq },
            dependent:   :destroy,
            class_name:  "Blocking",
            foreign_key: :blocker_id
        end

        def define_blocker_association_method(source_type)
          association_method_name = blocker_association_method_name_for source_type

          has_many association_method_name,
            ->(owner) { where(blockings: {blocker_type: owner.class.name}).uniq },
            through:     :blockings,
            source:      :blockee,
            source_type: source_type
        end
      end
    end
  end
end
