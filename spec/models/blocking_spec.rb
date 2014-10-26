require "spec_helper"

describe Blocking do
  it "should be invalid if blocker and blockee are not set" do
    expect { Blocking.create! }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
