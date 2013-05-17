require 'spec_helper'

describe EdgecastWrapper, :slow do
  let(:log_filename) { 'wac_841C_20130420_0050.log.gz' }
  let(:log_file) { fixture_file('wac_841C_20130420_0050.log.gz') }

  describe ".logs_filename" do
    it "yields log_filename" do
      EdgecastWrapper.logs_filename.should include log_filename
    end
  end

  describe ".log_file" do
    it "downloads log file" do
      EdgecastWrapper.log_file(log_filename) do |file|
        file.should be_kind_of(LogFile)
        file.size.should eq log_file.size
        file.path.to_s.should end_with log_filename
      end
    end
  end

  # Commented because it remove file for real... :)
  pending ".remove_log_file" do
    it "removes log file data" do
      file = EdgecastWrapper.remove_log_file(log_filename)
      EdgecastWrapper.logs_filename.should be_empty
    end
  end
end
