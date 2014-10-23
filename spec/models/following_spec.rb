require "spec_helper"

describe Following do
  it "should be invalid if follower and followee are not set" do
    expect { Following.create! }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
