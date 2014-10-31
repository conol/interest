require "active_support"

module Interest
  module Blockable
    module Blocking
      extend ActiveSupport::Concern

      included do
        belongs_to :blocker, polymorphic: true
        belongs_to :blockee, polymorphic: true

        validates :blocker, presence: true
        validates :blockee, presence: true

        validate :validate_blocking_relationships, if: :should_validate_blocking_relationships?

        scope :between, ->(a, b) {
          a_to_b = where(blocker: a, blockee: b).where_values.reduce(:and)
          b_to_a = where(blocker: b, blockee: a).where_values.reduce(:and)

          where a_to_b.or(b_to_a)
        }

        after_create :destroy_following_relationships
      end

      def destroy_following_relationships
        Interest.following_class.destroy_relationships_between blocker, blockee
      end

      def should_validate_blocking_relationships?
        blocker.is_a?(ActiveRecord::Base) and blockee.is_a?(ActiveRecord::Base)
      end

      def validate_blocking_relationships
        errors.add :blocker, :invalid unless blocker.blocker?
        errors.add :blockee, :invalid unless blockee.blockee?
        errors.add :blockee, :rejected if blocker.blocker? and not blocker.valid_blocking_for?(blockee)
      end

      module ClassMethods
        def destroy_relationships_between(a, b)
          between(a, b).destroy_all
        end
      end
    end
  end
end
