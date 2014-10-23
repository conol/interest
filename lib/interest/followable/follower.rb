require "active_support"

module Interest
  module Followable
    module Follower
      extend ActiveSupport::Concern

      def following?(followee)
        follower_association_method_for(followee).include? followee
      end

      def follow(followee)
        return nil if followee == self
        follower_association_method_for(followee) << followee
      end

      def unfollow(followee)
        follower_association_method_for(followee).delete followee
      end

      def follower_association_method_for(followee)
        __send__ self.class.follower_association_method_name_for(followee)
      end

      module ClassMethods
        def define_follower_association_methods(*args)
          class_name = name

          has_many :followings,
            -> { uniq },
            dependent:   :destroy,
            class_name:  "Following",
            foreign_key: :follower_id

          args.map(&:to_s).each do |source_type|
            association_method_name = follower_association_method_name_for source_type

            has_many association_method_name,
              -> { where(followings: {follower_type: class_name}).uniq },
              through:     :followings,
              source:      :followee,
              source_type: source_type
          end
        end

        def follower_association_method_name_for(followee)
          name = followee.is_a?(ActiveRecord::Base) ? followee.class.name : followee.to_s
          :"following_#{name.underscore.pluralize}"
        end
      end
    end
  end
end
