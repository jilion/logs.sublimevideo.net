require 'spec_helper'

describe LogReaderWorker do
  let(:log) { build_stubbed(:log) }
  let(:worker) { LogReaderWorker.new }
  it "delays job in stats queue" do
    LogReaderWorker.sidekiq_options_hash['queue'].should eq 'logs'
  end

  describe "#perform" do
    let(:queue) { double(Sidekiq::Queue, block: true, unblock: true) }

    before {
      Log.stub(:find) { log }
      log.stub(:update_attribute)
      Sidekiq::Queue.stub(:[]) { queue }
    }

    it "blocks and unblocks logs queue during performing" do
      queue.should_receive(:block)
      queue.should_receive(:unblock)
      worker.perform(log.id)
    end

    it "reads each line of logs and delay gif request parsing" do
      LogLineParserWorker.should_receive(:perform_async).exactly(1).times
      worker.perform(log.id)
    end

    it "skips header" do
      LogLineParserWorker.stub(:perform_async) do |line|
        line.should_not include '#Fields'
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
      log.should_receive(:update_attribute).with(:read_lines, 8)
      expect { worker.perform(log.id) }.to raise_error
    end

    it "skips alreay read lines" do
      log.stub(:read_lines) { 5 }
      LogLineParserWorker.should_receive(:perform_async).exactly(1).times
      worker.perform(log.id)
    end
  end
end
