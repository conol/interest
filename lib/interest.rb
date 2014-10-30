require "interest/version"
require "interest/base"
require "interest/followable"
require "interest/follow_requestable"
require "interest/blockable"
require "active_support"
require "active_support/core_ext/string/inflections"
require "active_record"

module Interest
  module Extension
    extend ActiveSupport::Concern

    included do
      include Base
      extend Followable::Extension
      extend FollowRequestable::Extension
      extend Blockable::Extension
    end

    module ClassMethods
      def interest
        acts_as_followable
        acts_as_follow_requestable
        acts_as_blockable
      end
    end
  end

  class << self
    def following_class_name
      "::Following"
    end

    def following_class
      @following_class ||= following_class_name.constantize
    end

    def blocking_class_name
      "::Blocking"
    end

    def blocking_class
      @blocking_class ||= blocking_class_name.constantize
    end
  end
end

ActiveRecord::Base.__send__ :include, Interest::Extension
