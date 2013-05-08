require 'spec_helper'

describe LogsCreator do
  let(:log_filename) { 'wac_841C_20130420_0050.log.gz' }
  let(:log_file) { fixture_file(log_filename) }
  let(:log) { mock(Log, id: 1) }

  describe ".shift_and_create_logs" do
    before {
      EdgecastWrapper.stub(:logs_filename) { [log_filename] }
      EdgecastWrapper.stub(:log_file).with(log_filename) { log_file }
      EdgecastWrapper.stub(:remove_log_file).with(log_filename)
      Log.stub(:create!) { log }
      LogReaderWorker.stub(:perform_async)
    }

    it "create log with file" do
      Log.should_receive(:create!).with(
        name: log_filename,
        provider: 'edgecast',
        file: log_file
      ) { log }
      LogsCreator.shift_and_create_logs
    end

    it "delays log reading" do
      LogReaderWorker.should_receive(:perform_async).with(log.id)
      LogsCreator.shift_and_create_logs
    end

    it "removes log file" do
      EdgecastWrapper.should_receive(:remove_log_file).with(log_filename)
      LogsCreator.shift_and_create_logs
    end
  end
end
