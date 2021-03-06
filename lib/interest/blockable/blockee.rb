require "active_support"
require "interest/definition"

module Interest
  module Blockable
    module Blockee
      extend ActiveSupport::Concern

      include Interest::Definition.instance_methods_for(:blockee, :blocker)

      def blocked_by?(blocker)
        blockee_collection_for(blockee).include? blocker
      end

      module ClassMethods
        include Interest::Definition.class_methods_for(:blockee, :blocker)

        def define_blockee_association_methods
          has_many :blocker_relationships,
            as:          :blockee,
            dependent:   :destroy,
            class_name:  Interest.blocking_class_name do
              include Interest::Definition.collection_methods_for(:blocker)
            end
        end

        def define_blockee_association_method(source_type)
          association_method_name = blockee_association_method_name_for source_type

          has_many association_method_name,
            through:     :blocker_relationships,
            source:      :blocker,
            source_type: source_type
        end
      end
    end
  end
end
