require 'spec_helper'

describe EdgecastWrapper, :slow do
  let(:log_filename) { 'wac_841C_20130420_0050.log.gz' }
  let(:log_file) { fixture_file('wac_841C_20130420_0050.log.gz') }

  describe ".logs_filename" do
    it "yields log_filename" do
      expect(EdgecastWrapper.logs_filename.first).to eq log_filename
    end
  end

  describe ".log_file" do
    it "downloads log file" do
      EdgecastWrapper.log_file(log_filename) do |file|
        expect(file).to be_kind_of(LogFile)
        expect(file.size).to eq log_file.size
        expect(file.path.to_s).to end_with log_filename
      end
    end
  end

  # Commented because it remove file for real... :)
  pending ".remove_log_file" do
    it "removes log file data" do
      file = EdgecastWrapper.remove_log_file(log_filename)
      expect(EdgecastWrapper.logs_filename).to be_empty
    end
  end
end
