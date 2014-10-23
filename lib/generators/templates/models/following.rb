class Following < ActiveRecord::Base
  include Interest::Followable::Following
end
