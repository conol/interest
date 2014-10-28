require "active_support"
require "interest/utils"
require "interest/definition"

module Interest
  module FollowRequestable
    module FollowRequestee
      extend ActiveSupport::Concern

      include Interest::Definition.instance_methods_for(:follow_requestee, :follow_requester)

      def requires_request_to_follow?(requester)
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def has_been_requested_to_follow?(requester)
        follow_requestee_association_method_for(requester).include? requester
      end

      module ClassMethods
        include Interest::Definition.class_methods_for(:follow_requestee, :follow_requester)

        def define_follow_requestee_association_methods
          has_many :incoming_follow_requests,
            -> { uniq },
            as:          :requestee,
            dependent:   :destroy,
            class_name:  "FollowRequest"
        end

        def define_follow_requestee_association_method(source_type)
          association_method_name = follow_requestee_association_method_name_for source_type

          has_many association_method_name,
            -> { uniq },
            through:     :incoming_follow_requests,
            source:      :requester,
            source_type: source_type
        end
      end
    end
  end
end
