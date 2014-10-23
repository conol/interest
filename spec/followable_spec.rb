require "spec_helper"

describe "Followable" do
  it "should follow other" do
    user       = User.create!
    other_user = User.create!

    user.follow(other_user)

    expect(user).to be_following(other_user)
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

  context "following several types" do
    let(:user) { User.create! }

    before do
      other_user = User.create!
      stuff      = Stuff.create!

      user.followings.destroy_all
      user.follow(other_user)
      user.follow(stuff)
    end

    it "should count all" do
      expect(user.followings.count).to eq(2)
    end

    it "should count each type correctly" do
      expect(user.following_users.count).to eq(1)
      expect(user.following_stuffs.count).to eq(1)
    end
  end
end
