require "spec_helper"

describe Blocking do
  it "should be invalid if blocker and blockee are not set" do
    expect { Blocking.create! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should destroy relationships between a and b" do
    a = BlockableUser.create!
    b = BlockableUser.create!

    a.block(b)
    b.block(a)

    Blocking.destroy_relationships_between(a, b)

    expect(Blocking.between(a, b)).to have_exactly(0).items
  end

  describe "between scope" do
    let(:a) { BlockableUser.create! }
    let(:b) { BlockableUser.create! }

    before do
      Blocking.destroy_relationships_between(a, b)

      a.block(b)
      b.block(a)
    end

    it "should get relationships between a and b" do
      expect(Blocking.between(a, b)).to have_exactly(2).items
    end
  end
end
