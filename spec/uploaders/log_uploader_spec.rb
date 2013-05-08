require 'spec_helper'

describe LogUploader do
  let(:log) { mock('log', provider: 'edgecast') }
  let(:uploader) { LogUploader.new(log, :file) }

  describe "#store_dir" do
    it "namespaces with provider" do
      uploader.store_dir.should include log.provider
    end
  end

end
