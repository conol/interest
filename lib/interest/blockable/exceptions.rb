require "interest/exception"

module Interest
  module Blockable
    module Exceptions
      class Exception < Interest::Exception; end
      class Rejected < Exception; end
    end

    include Exceptions
  end
end
