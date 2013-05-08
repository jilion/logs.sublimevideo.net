require 'spec_helper'

describe S3Wrapper do
  describe ".bucket" do
    it "returns bucket name" do
      S3Wrapper.bucket.should eq 'dev.sublimevideo'
    end
  end
end
