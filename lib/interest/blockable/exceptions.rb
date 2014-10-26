module Interest
  module Blockable
    module Exceptions
      class Exception < StandardError; end
      class Rejected < Exception; end
    end

    include Exceptions
  end
end
