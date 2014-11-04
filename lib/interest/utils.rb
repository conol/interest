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
          object.to_s.underscore.gsub("/", "_").pluralize
        end
      end

      def source_type_of(object, prefix = nil)
        case model_class_or_instance(object)
        when :instance
          object.class.model_name.to_s
        when :class
          object.model_name.to_s
        else
          source_type_from_letter_of(object, prefix)
        end
      end

      private

      def source_types_from_letter_of(object, prefix = nil)
        return to_enum(:source_types_from_letter_of, object, prefix) unless block_given?

        parts = object.to_s.split("_")

        ["", "::"].repeated_permutation(parts.size - 1).each do |permutation|
          name = permutation.map.with_index {|value, i| parts[i].camelize + value }.join

          yield(name << parts.last.classify)
          yield("#{prefix}::#{name}") unless prefix.nil?
        end
      end

      def source_type_from_letter_of(object, prefix = nil)
        source_types_from_letter_of(object, prefix).each do |source_type|
          begin
            source_type.constantize
            return source_type
          rescue
          end
        end

        raise "Could not determine source type from #{object.inspect}"
      end

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
