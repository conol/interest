require "active_support"

module Interest
  module Followable
    module Exceptions
      class Exception < StandardError; end
      class Rejected < Exception; end
    end
  end
end
