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
        requestee.requires_request_to_follow?(self)
      end

      def request_to_follow(requestee)
        return nil unless valid_follow_request_for?(requestee)
        follow_requester_association_method_for(requestee) << requestee rescue ActiveRecord::RecordNotUnique
        outgoing_follow_requests.find_by(requestee: requestee)
      end

      def request_to_follow!(requestee)
        request_to_follow requestee or raise Interest::FollowRequestable::Rejected
      end

      def cancel_request_to_follow(requestee)
        follow_requester_association_method_for(requestee).delete requestee
      end

      def has_requested_to_follow?(requestee)
        follow_requester_association_method_for(requestee).include? requestee
      end

      def valid_follow_request_for?(requestee)
        not (self == requestee or not follow_requestable?(requestee) or (follower? and following? requestee))
      end

      module ClassMethods
        include Interest::Definition.class_methods_for(:follow_requester, :follow_requestee)

        def define_follow_requester_association_methods
          has_many :outgoing_follow_requests,
            -> { uniq },
            as:          :requester,
            dependent:   :destroy,
            class_name:  "FollowRequest"
        end

        def define_follow_requester_association_method(source_type)
          association_method_name = follow_requester_association_method_name_for source_type

          has_many association_method_name,
            -> { uniq },
            through:     :outgoing_follow_requests,
            source:      :requestee,
            source_type: source_type
        end
      end
    end
  end
end
