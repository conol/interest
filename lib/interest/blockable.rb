require "interest/blockable/exceptions"
require "interest/blockable/blocking"
require "interest/blockable/blocker"
require "interest/blockable/blockee"

module Interest
  module Blockable
    module Extension
      def acts_as_blocker
        include Blocker
        define_blocker_association_methods
      end

      def acts_as_blockee
        include Blockee
        define_blockee_association_methods
      end

      def acts_as_blockable
        acts_as_blocker
        acts_as_blockee
      end
    end
  end
end
