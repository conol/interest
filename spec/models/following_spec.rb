require "spec_helper"

describe Following do
  it "should be invalid if follower and followee are not set" do
    expect { Following.create! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should let requester follow requestee when accepted request" do
    user       = FollowRequestableUser.create!
    other_user = FollowRequestableUser.create!

    user.request_to_follow(other_user).accept!

    expect(user).to be_following(other_user)
    expect(other_user).not_to be_following(user)
  end

  it "should change status when accepted request" do
    user       = FollowRequestableUser.create!
    other_user = FollowRequestableUser.create!

    follow_request = user.request_to_follow(other_user)
    follow_request.accept!

    expect(follow_request).to be_accepted
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

  it "should destroy relationships between a and b" do
    a = FollowRequestableUser.create!
    b = FollowRequestableUser.create!

    a.follow(b)
    b.follow(a)

    Following.destroy_relationships_between(a, b)

    expect(Following.between(a, b)).to have_exactly(0).items
  end

  describe "accepted and pending scopes" do
    before :all do
      Following.destroy_all

      2.times { FollowRequestableUser.create!.follow!(FollowRequestableUser.create!) }
      2.times { FollowRequestableUser.create!.request_to_follow!(FollowRequestableUser.create!) }
    end

    it "should get all following" do
      expect(Following.accepted).to be_present.and all be_accepted
    end

    it "should get all follow requests" do
      expect(Following.pending).to be_present.and all be_pending
    end
  end

  describe "between scope" do
    let(:a) { FollowRequestableUser.create! }
    let(:b) { FollowRequestableUser.create! }

    before do
      Following.destroy_relationships_between(a, b)

      a.follow(b)
      b.request_to_follow(a)
    end

    it "should get all relationships between a and b" do
      expect(Following.between(a, b)).to have_exactly(2).items
    end

    it "should get accepted relationship" do
      expect(Following.between(a, b).accepted).to have_exactly(1).items
    end

    it "should get pending relationship" do
      expect(Following.between(a, b).pending).to have_exactly(1).items
    end
  end
end
