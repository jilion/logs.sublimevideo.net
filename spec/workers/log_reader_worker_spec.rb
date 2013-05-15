require 'spec_helper'

describe LogReaderWorker do
  let(:log) { build_stubbed(:log) }
  let(:worker) { LogReaderWorker.new }

  it "delays job in stats queue" do
    LogReaderWorker.sidekiq_options_hash['queue'].should eq 'logs'
  end

  describe "#perform" do
    before {
      Log.stub(:find) { log }
      log.stub(:update_attribute)
    }

    it "reads each line of logs and delay parsing" do
      LogLineParserWorker.should_receive(:perform_async).exactly(9).times
      worker.perform(log.id)
    end

    it "skips header" do
      LogLineParserWorker.stub(:perform_async) do |line|
        line.should_not include '#Fields'
      end
       worker.perform(log.id)
    end

    it "removes \n from line" do
      LogLineParserWorker.stub(:perform_async) do |line|
        line.should_not include "\n"
      end
       worker.perform(log.id)
    end

    it "updates read_lines when finish" do
      log.should_receive(:update_attribute).with(:read_lines, 9)
      worker.perform(log.id)
    end

    it "sets read_at when finish" do
      log.should_receive(:touch).with(:read_at)
      worker.perform(log.id)
    end

    it "updates read_lines when failed" do
      LogLineParserWorker.stub(:perform_async).and_raise
      log.should_receive(:update_attribute).with(:read_lines, 0)
      expect { worker.perform(log.id) }.to raise_error
    end

    it "skips alreay read lines" do
      log.stub(:read_lines) { 5 }
      LogLineParserWorker.should_receive(:perform_async).exactly(4).times
      worker.perform(log.id)
    end
  end
end
