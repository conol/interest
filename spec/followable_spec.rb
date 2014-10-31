require "spec_helper"

describe "Followable" do
  it "should follow other" do
    user       = FollowableUser.create!
    other_user = FollowableUser.create!

    user.follow(other_user)

    expect(user).to be_following(other_user)
  end

  it "should not follow self and raise exception" do
    user = FollowableUser.create!

    expect { user.follow!(user) }.to raise_error(Interest::Followable::Rejected)
  end

  it "should not follow self" do
    user = FollowableUser.create!

    user.follow(user)

    expect(user.following_followable_users).to be_empty
  end

  it "should not duplicate followee" do
    user       = FollowableUser.create!
    other_user = FollowableUser.create!

    user.follow(other_user)
    user.follow(other_user)

    expect(user.following_relationships.count).to eq(1)
    expect(user.following_followable_users.count).to eq(1)
  end

  it "should be a Following" do
    user       = FollowableUser.create!
    other_user = FollowableUser.create!

    user.follow(other_user)

    expect(user.following_relationships.of(FollowableUser)).to be_present.and all be_a Following
  end

  it "should be a model is followed" do
    user       = FollowableUser.create!
    other_user = FollowableUser.create!
    stuff      = Stuff.create!

    user.follow(other_user)
    user.follow(stuff)

    expect(user.following_followable_users).to be_present.and all be_a FollowableUser
  end

  it "should follow several types" do
    user       = FollowableUser.create!
    other_user = FollowableUser.create!
    stuff      = Stuff.create!

    user.follow(other_user)
    user.follow(stuff)

    expect(user).to be_following(other_user)
    expect(user).to be_following(stuff)
  end

  it "should unfollow" do
    user       = FollowableUser.create!
    other_user = FollowableUser.create!

    user.follow(other_user)
    user.unfollow(other_user)

    expect(user).not_to be_following(other_user)
  end

  it "should determine if self is followed by other" do
    user             = FollowableUser.create!
    other_user       = FollowableUser.create!
    indifferent_user = FollowableUser.create!

    other_user.follow(user)

    expect(user).to be_followed_by(other_user)
    expect(user).not_to be_followed_by(indifferent_user)
  end

  context "following several types" do
    let(:user) { FollowableUser.create! }
    let(:popular_user) { FollowableUser.create! }

    before do
      other_user = FollowableUser.create!
      stuff      = Stuff.create!
      collection = Collection.create!

      user.following_relationships.destroy_all
      popular_user.follower_relationships.destroy_all

      user.follow(other_user)
      user.follow(stuff)
      user.follow(collection)
      user.follow(popular_user)
      other_user.follow(popular_user)
      collection.follow(popular_user)
    end

    it "should count following" do
      expect(user.following_relationships.count).to eq(4)
    end

    it "should count each type of followings" do
      expect(user.following_followable_users.count).to eq(2)
      expect(user.following_stuffs.count).to eq(1)
      expect(user.following_collections.count).to eq(1)
    end

    it "should count followers" do
      expect(popular_user.follower_relationships.count).to eq(3)
    end

    it "should count each type of followers" do
      expect(popular_user.follower_followable_users.count).to eq(2)
      expect(popular_user.follower_collections.count).to eq(1)
    end
  end

  it "should destroy their follow requests when either requester or requestee follows other" do
    user       = FollowRequestableUser.create!
    other_user = FollowRequestableUser.create!

    user.request_to_follow(other_user)
    other_user.request_to_follow(user)

    user.follow(other_user)

    expect(user).not_to have_requested_to_follow(other_user)
    expect(other_user).not_to have_been_requested_to_follow(user)
  end

  it "should find outgoing following of specified type" do
    user        = FollowableUser.create!
    other_user1 = FollowableUser.create!
    other_user2 = FollowableUser.create!
    collection  = Collection.create!

    user.follow(other_user1)
    user.follow(other_user2)
    user.follow(collection)

    expect(user.following_relationships.of(FollowableUser)).to have_exactly(2).items
    expect(user.following_relationships.of(Collection)).to have_exactly(1).items
  end

  it "should find incoming following of specified type" do
    user        = FollowableUser.create!
    other_user1 = FollowableUser.create!
    other_user2 = FollowableUser.create!
    collection  = Collection.create!

    other_user1.follow(user)
    other_user2.follow(user)
    collection.follow(user)

    expect(user.follower_relationships.of(FollowableUser)).to have_exactly(2).items
    expect(user.follower_relationships.of(Collection)).to have_exactly(1).items
  end
end
