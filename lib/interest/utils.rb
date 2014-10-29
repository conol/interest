require "active_support"
require "active_support/core_ext/string/inflections"
require "active_record"

module Interest
  module Utils
    class << self
      def symbolic_name_of(object)
        if object.is_a?(ActiveRecord::Base)
          object.class.name
        elsif object.is_a?(Class) and object < ActiveRecord::Base
          object.name
        else
          object.to_s
        end.underscore.pluralize
      end

      def source_type_of(object)
        if object.is_a?(ActiveRecord::Base)
          object.class.name
        elsif object.is_a?(Class) and object < ActiveRecord::Base
          object.name
        else
          object.to_s.classify
        end
      end
    end
  end
end
