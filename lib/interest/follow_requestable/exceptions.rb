module Interest
  module FollowRequestable
    module Exceptions
      class Exception < StandardError; end
      class Rejected < Exception; end
    end

    include Exceptions
  end
end
