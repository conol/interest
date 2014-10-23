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
      end
    end
  end
end
