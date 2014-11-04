require "active_record"
require "interest"

module Deeply
  module Nested
    module Namespace
      class Stuff < ActiveRecord::Base
        interest
      end
    end
  end
end
