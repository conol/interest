require "active_support"

module Interest
  module Followable
    module Following
      extend ActiveSupport::Concern

      included do
        belongs_to :follower, polymorphic: true
        belongs_to :followee, polymorphic: true

        validates :follower, presence: true
        validates :followee, presence: true
        validates :status, presence: true, inclusion: {in: %w(pending accepted)}

        validate :validate_following_relationships, if: :should_validate_following_relationships?

        scope :accepted, -> { where(status: "accepted") }
        scope :pending, -> { where(status: "pending") }

        scope :between, ->(a, b) {
          a_to_b = where(follower: a, followee: b).where_values.reduce(:and)
          b_to_a = where(follower: b, followee: a).where_values.reduce(:and)

          where a_to_b.or(b_to_a)
        }
      end

      def accepted?
        status == "accepted"
      end

      def pending?
        status == "pending"
      end

      def mutual
        followee.follow(follower)
      end

      def mutual!
        followee.follow!(follower)
      end

      def should_validate_following_relationships?
        accepted? and follower.is_a?(ActiveRecord::Base) and followee.is_a?(ActiveRecord::Base)
      end

      def validate_following_relationships
        errors.add :follower, :invalid unless follower.follower?
        errors.add :followee, :invalid unless followee.followee?
        errors.add :followee, :rejected if follower.follower? and not follower.valid_following_for?(followee)
      end

      module ClassMethods
        def destroy_relationships_between(a, b)
          between(a, b).destroy_all
        end
      end
    end
  end
end
