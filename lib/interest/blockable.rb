require "active_support"
require "interest/blockable/exceptions"
require "interest/blockable/blocking"
require "interest/blockable/blocker"
require "interest/blockable/blockee"

module Interest
  module Blockable
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_blocker(*args)
        include Blocker
        define_blocker_association_methods *args
      end

      def acts_as_blockee(*args)
        include Blockee
        define_blockee_association_methods *args
      end

      def acts_as_blockable
        acts_as_blocker
        acts_as_blockee
      end
    end
  end
end
