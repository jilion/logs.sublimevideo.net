require 'spec_helper'

describe LogUploader do
  let(:log) { double('log', provider: 'edgecast') }
  let(:uploader) { LogUploader.new(log, :file) }

  describe "#store_dir" do
    it "namespaces with provider" do
      expect(uploader.store_dir).to include "logs/#{log.provider}"
    end
  end
end
