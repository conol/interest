require "active_support"
require "active_record"
require "interest/utils"
require "interest/definition"
require "interest/follow_requestable/exceptions"
require "interest/follow_requestable/follow_requestee"

module Interest
  module FollowRequestable
    module FollowRequester
      extend ActiveSupport::Concern

      include Interest::Definition.instance_methods_for(:follow_requester, :follow_requestee)

      def required_request_to_follow?(requestee)
        requestee.follow_requestee? and requestee.requires_request_to_follow?(self)
      end

      def request_to_follow(requestee, raise_record_invalid = false)
        outgoing_follow_requests.create!(followee: requestee)
      rescue ActiveRecord::RecordInvalid => exception
        raise_record_invalid ? (raise exception) : nil
      rescue ActiveRecord::RecordNotUnique
        outgoing_follow_requests.find_by(followee: requestee)
      end

      def request_to_follow!(requestee)
        request_to_follow(requestee, true)
      rescue ActiveRecord::RecordInvalid => exception
        raise Interest::FollowRequestable::Rejected.new(exception)
      end

      def cancel_request_to_follow(requestee)
        follow_requester_collection_for(requestee).delete requestee
      end

      def has_requested_to_follow?(requestee)
        follow_requester_collection_for(requestee).include? requestee
      end

      def valid_follow_request_for?(requestee)
        not (self == requestee or not follow_requestable?(requestee) or (follower? and following? requestee))
      end

      def follow_or_request_to_follow!(other)
        if required_request_to_follow? other
          returned = request_to_follow! other
          which    = :request_to_follow
        else
          returned = follow! other
          which    = :follow
        end

        FollowOrRequestToFollow.new which, returned, other
      end

      class FollowOrRequestToFollow < Struct.new(:which, :returned, :target)
        def followed?
          which == :follow
        end

        def requested_to_follow?
          which == :request_to_follow
        end
      end

      module ClassMethods
        include Interest::Definition.class_methods_for(:follow_requester, :follow_requestee)

        def define_follow_requester_association_methods
          has_many :outgoing_follow_requests,
            -> { where(followings: {status: "pending"}) },
            as:          :follower,
            dependent:   :destroy,
            class_name:  "Following" do
              include Interest::Definition.collection_methods_for(:followee)
            end
        end

        def define_follow_requester_association_method(source_type)
          association_method_name = follow_requester_association_method_name_for source_type

          has_many association_method_name,
            through:     :outgoing_follow_requests,
            source:      :followee,
            source_type: source_type
        end
      end
    end
  end
end
