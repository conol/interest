require "active_support"
require "interest/followable/exceptions"
require "interest/followable/followee"

module Interest
  module Followable
    module Follower
      extend ActiveSupport::Concern

      def followable?(followee)
        followee.is_a?(Interest::Followable::Followee)
      end

      def following?(followee)
        follower_association_method_for(followee).include? followee
      end

      def follow(followee)
        return nil if followee == self or not followable?(followee)
        follower_association_method_for(followee) << followee
      end

      def follow!(followee)
        follow followee or raise Interest::Followable::Exceptions::Rejected
      end

      def unfollow(followee)
        follower_association_method_for(followee).delete followee
      end

      def follower_association_method_for(followee)
        __send__ self.class.follower_association_method_name_for(followee)
      end

      def method_missing(name, *args)
        return super if args.present? or block_given?
        return super unless /\Afollowing_(?<type>.+)\Z/ =~ name.to_s

        self.class.define_follower_association_method type.classify

        __send__ name
      end

      module ClassMethods
        def define_follower_association_methods(*args)
          has_many :followings,
            -> { uniq },
            dependent:   :destroy,
            class_name:  "Following",
            foreign_key: :follower_id
        end

        def define_follower_association_method(source_type)
          class_name              = name
          association_method_name = follower_association_method_name_for source_type

          has_many association_method_name,
            -> { where(followings: {follower_type: class_name}).uniq },
            through:     :followings,
            source:      :followee,
            source_type: source_type
        end

        def follower_association_method_name_for(followee)
          name = followee.is_a?(ActiveRecord::Base) ? followee.class.name : followee.to_s
          :"following_#{name.underscore.pluralize}"
        end
      end
    end
  end
end
