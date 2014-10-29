require "active_support"
require "active_support/core_ext/string/inflections"
require "active_record"

module Interest
  module Utils
    class << self
      def symbolic_name_of(object)
        name = object.is_a?(ActiveRecord::Base) ? object.class.name : object.to_s
        name.underscore.pluralize
      end
    end
  end
end
