require "spec_helper"

describe "Followable" do
  it "should follow other" do
    user       = User.create!
    other_user = User.create!

    user.follow(other_user)

    expect(user).to be_following(other_user)
  end

  it "should not follow self and raise exception" do
    user = User.create!

    expect { user.follow!(user) }.to raise_error(Interest::Followable::Exceptions::Rejected)
  end

  it "should not follow self" do
    user = User.create!

    user.follow(user)

    expect(user.following_users).to be_empty
  end

  it "should not duplicate followee" do
    user       = User.create!
    other_user = User.create!

    user.follow(other_user)
    user.follow(other_user)

    expect(user.following_users.count).to eq(1)
  end

  it "should follow several types" do
    user       = User.create!
    other_user = User.create!
    stuff      = Stuff.create!

    user.follow(other_user)
    user.follow(stuff)

    expect(user).to be_following(other_user)
    expect(user).to be_following(stuff)
  end

  it "should unfollow" do
    user       = User.create!
    other_user = User.create!

    user.follow(other_user)
    user.unfollow(other_user)

    expect(user).not_to be_following(other_user)
  end

  it "should determine if self is followed by other" do
    user             = User.create!
    other_user       = User.create!
    indifferent_user = User.create!

    other_user.follow(user)

    expect(user).to be_followed_by(other_user)
    expect(user).not_to be_followed_by(indifferent_user)
  end

  context "following several types" do
    let(:user) { User.create! }
    let(:popular_user) { User.create! }

    before do
      other_user = User.create!
      stuff      = Stuff.create!
      collection = Collection.create!

      user.followings.destroy_all
      popular_user.followers.destroy_all

      user.follow(other_user)
      user.follow(stuff)
      user.follow(collection)
      user.follow(popular_user)
      other_user.follow(popular_user)
      collection.follow(popular_user)
    end

    it "should count followings" do
      expect(user.followings.count).to eq(4)
    end

    it "should count each type of followings" do
      expect(user.following_users.count).to eq(2)
      expect(user.following_stuffs.count).to eq(1)
      expect(user.following_collections.count).to eq(1)
    end

    it "should count followers" do
      expect(popular_user.followers.count).to eq(3)
    end

    it "should count each type of followers" do
      expect(popular_user.follower_users.count).to eq(2)
      expect(popular_user.follower_collections.count).to eq(1)
    end
  end
end
