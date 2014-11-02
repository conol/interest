require "active_support"
require "active_support/core_ext/string/inflections"
require "active_record"
require "active_model/naming"

module Interest
  module Utils
    class << self
      def symbolic_name_of(object)
        if model_class_or_instance(object)
          ActiveModel::Naming.plural(object)
        else
          object.to_s.underscore.pluralize
        end
      end

      def source_type_of(object)
        case model_class_or_instance(object)
        when :instance
          object.class.model_name.to_s
        when :class
          object.model_name.to_s
        else
          object.to_s.classify
        end
      end

      private

      def model_class_or_instance(object)
        if object.is_a?(ActiveRecord::Base)
          :instance
        elsif object.is_a?(Class) && object < ActiveRecord::Base
          :class
        else
          nil
        end
      end
    end
  end
end
