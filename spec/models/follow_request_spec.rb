require "spec_helper"

describe FollowRequest do
  it "should be invalid if sender and receiver are not set" do
    expect { FollowRequest.create! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should let requester follow requestee when accepted request" do
    user       = FollowRequestableUser.create!
    other_user = FollowRequestableUser.create!

    user.request_to_follow(other_user).accept!

    expect(user).to be_following(other_user)
    expect(other_user).not_to be_following(user)
  end

  it "should destroy when accepted request" do
    user       = FollowRequestableUser.create!
    other_user = FollowRequestableUser.create!

    follow_request = user.request_to_follow(other_user)
    follow_request.accept!

    expect(follow_request).to be_destroyed
  end

  it "should destroy when rejected request" do
    user       = FollowRequestableUser.create!
    other_user = FollowRequestableUser.create!

    follow_request = user.request_to_follow(other_user)
    follow_request.reject!

    expect(follow_request).to be_destroyed
  end

  it "should follow each other" do
    user       = FollowRequestableUser.create!
    other_user = FollowRequestableUser.create!

    request = user.request_to_follow(other_user)
    request.accept_mutual_follow!

    expect(user).to be_following(other_user)
    expect(other_user).to be_following(user)
  end
end
