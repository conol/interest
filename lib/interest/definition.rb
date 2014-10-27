require "active_support"
require "interest/utils"

module Interest
  module Definition
    class << self
      def instance_methods_for(source, target)
        Module.new do
          define_method :"#{source}_association_method_for" do |record|
            __send__ self.class.__send__(:"#{source}_association_method_name_for", record)
          end

          define_method :method_missing do |name, *args, &block|
            return super(name, *args, &block) if args.present? or block.present?
            return super(name, *args, &block) unless matches = /\A#{target}_(?<type>.+)\Z/.match(name.to_s)

            self.class.__send__ :"define_#{source}_association_method", matches[:type].classify

            __send__ name
          end
        end
      end

      def class_methods_for(source, target)
        Module.new do
          define_method :"#{source}_association_method_name_for" do |record|
            :"#{target}_#{Interest::Utils.symbolic_name_of record}"
          end
        end
      end
    end
  end
end