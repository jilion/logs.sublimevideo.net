require 'spec_helper'

describe LogsCreator do
  let(:log_filename) { 'wac_841C_20130420_0050.log.gz' }
  let(:log_file) { fixture_file(log_filename) }
  let(:log) { double(Log, id: 1) }

  describe ".shift_and_create_logs" do
    before {
      EdgecastWrapper.stub(:logs_filename) { [log_filename] }
      EdgecastWrapper.stub(:log_file).with(log_filename).and_yield(log_file)
      EdgecastWrapper.stub(:remove_log_file).with(log_filename)
      Log.stub(:create) { true }
      Log.stub_chain(:where, :first) { log }
      LogReaderWorker.stub(:perform_async)
    }

    it "creates log with file" do
      expect(Log).to receive(:create).with(
        name: log_filename,
        provider: 'edgecast',
        file: log_file
      )
      LogsCreator.shift_and_create_logs
    end

    it "delays log reading" do
      expect(LogReaderWorker).to receive(:perform_async).with(log.id)
      LogsCreator.shift_and_create_logs
    end

    it "removes log file" do
      expect(EdgecastWrapper).to receive(:remove_log_file).with(log_filename)
      LogsCreator.shift_and_create_logs
    end

    context "with already the same existing log" do
      before { Log.stub(:create) { false } }

      it "still delays log reading" do
        expect(LogReaderWorker).to receive(:perform_async).with(log.id)
        LogsCreator.shift_and_create_logs
      end

      it "still removes log file" do
        expect(EdgecastWrapper).to receive(:remove_log_file).with(log_filename)
        LogsCreator.shift_and_create_logs
      end
    end
  end
end
