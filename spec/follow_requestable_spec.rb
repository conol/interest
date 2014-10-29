require "spec_helper"

describe "FollowRequestable" do
  it "should follow request" do
    user       = FollowRequestableUser.create!
    other_user = FollowRequestableUser.create!

    user.request_to_follow(other_user)

    expect(user).to have_requested_to_follow(other_user)
    expect(other_user).to have_been_requested_to_follow(user)
  end

  it "should not duplicate follow request" do
    user       = FollowRequestableUser.create!
    other_user = FollowRequestableUser.create!

    user.request_to_follow(other_user)
    user.request_to_follow(other_user)

    expect(user.outgoing_follow_requests.count).to eq(1)
    expect(user.follow_requestee_follow_requestable_users.count).to eq(1)
  end

  it "should cancel follow request" do
    user       = FollowRequestableUser.create!
    other_user = FollowRequestableUser.create!

    user.request_to_follow(other_user)
    user.cancel_request_to_follow(other_user)

    expect(user).not_to have_requested_to_follow(other_user)
    expect(other_user).not_to have_been_requested_to_follow(user)
  end

  it "should not follow request self" do
    user = FollowRequestableUser.create!

    user.request_to_follow(user)

    expect(user).not_to have_been_requested_to_follow(user)
  end

  it "should not follow request self and raise exception" do
    user = FollowRequestableUser.create!

    expect { user.request_to_follow!(user) }.to raise_error(Interest::FollowRequestable::Rejected)
  end

  it "should not follow request if already following" do
    user       = FollowRequestableUser.create!
    other_user = FollowRequestableUser.create!

    user.follow(other_user)

    expect { user.request_to_follow!(other_user) }.to raise_error(Interest::FollowRequestable::Rejected)
  end

  it "should not follow request if blocked" do
    user       = FollowRequestableAndBlockableUser.create!
    other_user = FollowRequestableAndBlockableUser.create!

    other_user.block(user)

    expect { user.request_to_follow!(other_user) }.to raise_error(Interest::FollowRequestable::Rejected)
  end

  it "should follow or request to follow" do
    user       = FollowRequestableUser.create!
    other_user = FollowRequestableUser.create!

    allow(user).to receive(:requires_request_to_follow?).and_return(true)
    allow(other_user).to receive(:requires_request_to_follow?).and_return(false)

    expect(user.follow_or_request_to_follow!(other_user).followed?).to eq(true)
    expect(other_user.follow_or_request_to_follow!(user).requested_to_follow?).to eq(true)
  end

  it "should find outgoing follow request of specified type" do
    user        = FollowRequestableUser.create!
    other_user1 = FollowRequestableUser.create!
    other_user2 = FollowRequestableUser.create!
    collection  = Collection.create!

    user.request_to_follow(other_user1)
    user.request_to_follow(other_user2)
    user.request_to_follow(collection)

    expect(user.outgoing_follow_requests.of(FollowRequestableUser)).to have_exactly(2).items
    expect(user.outgoing_follow_requests.of(Collection)).to have_exactly(1).items
  end

  it "should find incoming follow request of specified type" do
    user        = FollowRequestableUser.create!
    other_user1 = FollowRequestableUser.create!
    other_user2 = FollowRequestableUser.create!
    collection  = Collection.create!

    other_user1.request_to_follow(user)
    other_user2.request_to_follow(user)
    collection.request_to_follow(user)

    expect(user.incoming_follow_requests.of(FollowRequestableUser)).to have_exactly(2).items
    expect(user.incoming_follow_requests.of(Collection)).to have_exactly(1).items
  end
end
