require "active_support"
require "active_record"
require "interest/utils"
require "interest/definition"
require "interest/followable/exceptions"
require "interest/followable/followee"

module Interest
  module Followable
    module Follower
      extend ActiveSupport::Concern

      include Interest::Definition.instance_methods_for(:follower, :following)

      def following?(followee)
        follower_association_method_for(followee).include? followee
      end

      def follow(followee)
        return nil unless valid_following_for?(followee)

        transaction do
          cancel_request_to_follow followee if follow_requester?
          followee.cancel_request_to_follow self if followee.follow_requester?

          collection = follower_association_method_for followee

          begin
            collection << followee
          rescue ActiveRecord::RecordNotUnique
            collection
          end
        end
      end

      def follow!(followee)
        follow followee or raise Interest::Followable::Rejected
      end

      def unfollow(followee)
        follower_association_method_for(followee).delete followee
      end

      def valid_following_for?(followee)
        not (followee == self or not followable?(followee))
      end

      module ClassMethods
        include Interest::Definition.class_methods_for(:follower, :following)

        def define_follower_association_methods
          has_many :following_relationships,
            -> { uniq },
            as:          :follower,
            dependent:   :destroy,
            class_name:  "Following"
        end

        def define_follower_association_method(source_type)
          association_method_name = follower_association_method_name_for source_type

          has_many association_method_name,
            -> { uniq },
            through:     :following_relationships,
            source:      :followee,
            source_type: source_type
        end
      end
    end
  end
end
