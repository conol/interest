require "interest/exception"

module Interest
  module Followable
    module Exceptions
      class Exception < Interest::Exception; end
      class Rejected < Exception; end
    end

    include Exceptions
  end
end
