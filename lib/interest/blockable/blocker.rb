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
        super and not (other.blockee? and blocking?(other)) and not (blockee? and other.blocker? and other.blocking? self)
      end

      def blocking?(blockee)
        blocker_collection_for(blockee).include? blockee
      end

      def block(blockee)
        return nil unless valid_blocking_for?(blockee)

        transaction do
          ::Following.destroy_relationships_between self, blockee

          begin
            blocking_relationships.create!(blockee: blockee)
          rescue ActiveRecord::RecordNotUnique
            blocking_relationships.find_by(blockee: blockee)
          end
        end
      end

      def block!(blockee)
        block blockee or raise Interest::Blockable::Rejected
      end

      def unblock(blockee)
        blocker_collection_for(blockee).delete blockee
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
            class_name:  "Blocking" do
              include Interest::Definition.collection_methods_for(:blockee)
            end
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
