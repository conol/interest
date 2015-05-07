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
        follower_collection_for(followee).include? followee
      end

      def follow(followee, raise_record_invalid = false)
        following_relationships.create!(followee: followee)
      rescue ActiveRecord::RecordInvalid => exception
        raise_record_invalid ? (raise exception) : nil
      rescue ActiveRecord::RecordNotUnique
        if follow_requester? and followee.follow_requestee?
          outgoing_follow_requests.find_by(followee: followee).try(:accept!)
        end or following_relationships.find_by(followee: followee)
      end

      def follow!(followee)
        follow(followee, true)
      rescue ActiveRecord::RecordInvalid => exception
        raise Interest::Followable::Rejected.new(exception)
      end

      def unfollow(followee)
        follower_collection_for(followee).delete followee
      end

      def valid_following_for?(followee)
        not (followee == self or not followable?(followee))
      end

      module ClassMethods
        include Interest::Definition.class_methods_for(:follower, :following)

        def define_follower_association_methods
          has_many :following_relationships,
            -> { where(Interest.following_class.table_name.to_sym => {status: "accepted"}) },
            as:          :follower,
            dependent:   :destroy,
            class_name:  Interest.following_class_name do
              include Interest::Definition.collection_methods_for(:followee)
            end
        end

        def define_follower_association_method(source_type)
          association_method_name = follower_association_method_name_for source_type

          has_many association_method_name,
            through:     :following_relationships,
            source:      :followee,
            source_type: source_type
        end
      end
    end
  end
end
