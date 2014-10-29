class Following < ActiveRecord::Base
  include Interest::Followable::Following
  include Interest::FollowRequestable::FollowRequest
end
