require 'spec_helper'

describe LogFile do
  let(:name) { 'wac_841C_20130420_0050.log.gz' }
  let(:file) { fixture_file(name) }
  let(:content) { file.read }
  let(:log_file) { LogFile.new(name, content) }

  describe ".open!" do
    it "yields with the log file" do
      LogFile.open!(name, content) do |file|
        expect(file.read).to eq content
      end
    end

    it "deletes file after yield" do
      LogFile.open!(name, content) do |file|
        @file = file
      end
      expect(File.exists?(@file.path)).to be_false
    end

    it "returns block result" do
      result = LogFile.open!(name, content) do |file|
        42
      end
      expect(result).to eq 42
    end
  end
end
