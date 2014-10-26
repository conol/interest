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
      end
    end
  end
end
