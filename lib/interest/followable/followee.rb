require "active_support"
require "interest/utils"
require "interest/definition"

module Interest
  module Followable
    module Followee
      extend ActiveSupport::Concern

      include Interest::Definition.instance_methods_for(:followee, :follower)

      def followed_by?(follower)
        followee_association_method_for(follower).include? follower
      end

      module ClassMethods
        include Interest::Definition.class_methods_for(:followee, :follower)

        def define_followee_association_methods(*args)
          has_many :follower_relationships,
            -> { uniq },
            as:          :followee,
            dependent:   :destroy,
            class_name:  "Following"
        end

        def define_followee_association_method(source_type)
          association_method_name = followee_association_method_name_for source_type

          has_many association_method_name,
            -> { uniq },
            through:     :follower_relationships,
            source:      :follower,
            source_type: source_type
        end
      end
    end
  end
end
