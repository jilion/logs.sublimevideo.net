require 'spec_helper'

describe LogFile do
  let(:name) { 'wac_841C_20130420_0050.log.gz' }
  let(:file) { fixture_file(name) }
  let(:content) { file.read }
  let(:log_file) { LogFile.new(name, content) }

  describe ".open!" do
    it "yields with the log file" do
      LogFile.open!(name, content) do |file|
        file.read.should eq content
      end
    end

    it "deletes file after yield" do
      LogFile.open!(name, content) do |file|
        @file = file
      end
      File.exists?(@file.path).should be_false
    end
  end
end
