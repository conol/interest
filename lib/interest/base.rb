require "active_support"

module Interest
  module Base
    extend ActiveSupport::Concern

    def followable?
      false
    end

    def blockable?
      false
    end

    module ClassMethods
    end
  end
end
