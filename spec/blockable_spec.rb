require "spec_helper"

describe "Blockable" do
  it "should block other" do
    user       = BlockableUser.create!
    other_user = BlockableUser.create!

    user.block(other_user)

    expect(user).to be_blocking(other_user)
  end

  it "should not block self" do
    user = BlockableUser.create!

    user.block(user)

    expect(user).not_to be_blocking(user)
  end

  it "should not duplicate blockee" do
    user       = BlockableUser.create!
    other_user = BlockableUser.create!

    user.block(other_user)
    user.block(other_user)

    expect(user.blocking_relationships.count).to eq(1)
    expect(user.blocking_blockable_users.count).to eq(1)
  end

  it "should not block self and raise exception" do
    user = BlockableUser.create!

    expect { user.block!(user) }.to raise_error(Interest::Blockable::Rejected)
  end

  it "should be followed by other user if user is not blocking one" do
    user       = FollowableAndBlockableUser.create!
    other_user = FollowableAndBlockableUser.create!

    expect { other_user.follow!(user) }.not_to raise_error
  end

  it "should not be followed by other user if user is blocking one" do
    user       = FollowableAndBlockableUser.create!
    other_user = FollowableAndBlockableUser.create!

    user.block(other_user)

    expect { other_user.follow!(user) }.to raise_error(Interest::Followable::Rejected)
  end

  it "should destroy their followship when either follower or followee blocks other" do
    user       = FollowableAndBlockableUser.create!
    other_user = FollowableAndBlockableUser.create!

    user.follow(other_user)
    other_user.follow(user)

    user.block(other_user)

    expect(user).not_to be_following(other_user)
    expect(other_user).not_to be_following(user)
  end

  it "should destroy their follow requests when either requester or requestee blocks other" do
    user       = FollowRequestableAndBlockableUser.create!
    other_user = FollowRequestableAndBlockableUser.create!

    user.request_to_follow(other_user)
    other_user.request_to_follow(user)

    user.block(other_user)

    expect(user).not_to have_requested_to_follow(other_user)
    expect(other_user).not_to have_been_requested_to_follow(user)
  end
end
