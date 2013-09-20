require 'spec_helper'

describe LogReaderWorker do
  let(:log) { build_stubbed(:log) }
  let(:worker) { LogReaderWorker.new }
  it "delays job in stats queue" do
    expect(LogReaderWorker.sidekiq_options_hash['queue']).to eq 'logs'
  end

  describe "#perform" do
    let(:queue) { double(Sidekiq::Queue, block: true, unblock: true) }

    before {
      Log.stub(:find) { log }
      log.stub(:update_attribute)
      Sidekiq::Queue.stub(:[]) { queue }
    }

    it "blocks and unblocks logs queue during performing" do
      expect(queue).to receive(:block)
      expect(queue).to receive(:unblock)
      worker.perform(log.id)
    end

    it "reads each line of logs and delay gif request parsing" do
      expect(LogLineParserWorker).to receive(:perform_async).exactly(1).times
      worker.perform(log.id)
    end

    it "skips header" do
      LogLineParserWorker.stub(:perform_async) do |line|
        expect(line).not_to include '#Fields'
      end
       worker.perform(log.id)
    end

    it "updates read_lines when finish" do
      expect(log).to receive(:update_attribute).with(:read_lines, 9)
      worker.perform(log.id)
    end

    it "sets read_at when finish" do
      expect(log).to receive(:touch).with(:read_at)
      worker.perform(log.id)
    end

    it "updates read_lines when failed" do
      LogLineParserWorker.stub(:perform_async).and_raise
      expect(log).to receive(:update_attribute).with(:read_lines, 8)
      expect { worker.perform(log.id) }.to raise_error
    end

    it "skips alreay read lines" do
      log.stub(:read_lines) { 5 }
      expect(LogLineParserWorker).to receive(:perform_async).exactly(1).times
      worker.perform(log.id)
    end
  end
end
