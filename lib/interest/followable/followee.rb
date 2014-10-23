require "active_support"

module Interest
  module Followable
    module Followee
      extend ActiveSupport::Concern

      def followed_by?(follower)
        followee_association_method_for(follower).include? follower
      end

      def followee_association_method_for(follower)
        __send__ self.class.followee_association_method_name_for(follower)
      end

      def method_missing(name, *args)
        return super if args.present? or block_given?
        return super unless /\Afollower_(?<type>.+)\Z/ =~ name.to_s

        self.class.define_followee_association_method type.classify

        __send__ name
      end

      module ClassMethods
        def define_followee_association_methods(*args)
          has_many :followers,
            -> { uniq },
            dependent:   :destroy,
            class_name:  "Following",
            foreign_key: :followee_id
        end

        def define_followee_association_method(source_type)
          class_name              = name
          association_method_name = followee_association_method_name_for source_type

          has_many association_method_name,
            -> { where(followings: {followee_type: class_name}).uniq },
            through:     :followers,
            source:      :follower,
            source_type: source_type
        end

        def followee_association_method_name_for(follower)
          name = follower.is_a?(ActiveRecord::Base) ? follower.class.name : follower.to_s
          :"follower_#{name.underscore.pluralize}"
        end
      end
    end
  end
end
