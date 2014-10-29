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
      end

      def accepted?
        status == "accepted"
      end

      def pending?
        status == "pending"
      end

      module ClassMethods
        def destroy_relationships_between(a, b)
          a_to_b = where(follower: a, followee: b).where_values.reduce(:and)
          b_to_a = where(follower: b, followee: a).where_values.reduce(:and)

          where(a_to_b.or(b_to_a)).destroy_all
        end
      end
    end
  end
end
