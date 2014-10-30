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

        after_create :destroy_following_relationships
      end

      def destroy_following_relationships
        ::Following.destroy_relationships_between blocker, blockee
      end
    end
  end
end
