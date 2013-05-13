require 'spec_helper'

describe LogReaderWorker do
  let(:log) { build_stubbed(:log) }
  let(:worker) { LogReaderWorker.new }

  describe "#perform" do
    before {
      Log.stub(:find) { log }
      log.stub(:update_attribute)
    }

    it "reads each line of logs and delay parsing" do
      LogLineParserWorker.should_receive(:perform_async).exactly(10).times
      worker.perform(log.id)
    end

    it "updates parsed_lines when finish" do
      log.should_receive(:update_attribute).with(:parsed_lines, 10)
      worker.perform(log.id)
    end

    it "updates parsed_lines when failed" do
      LogLineParserWorker.stub(:perform_async).and_raise
      log.should_receive(:update_attribute).with(:parsed_lines, 0)
      expect { worker.perform(log.id) }.to raise_error
    end

    it "skips alreay parsed lines" do
      log.stub(:parsed_lines) { 5 }
      LogLineParserWorker.should_receive(:perform_async).exactly(5).times
      worker.perform(log.id)
    end
  end
end
