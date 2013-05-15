require 'spec_helper'

describe LogLineParserWorker do
  let(:worker) { LogLineParserWorker.new }

  it "delays job in stats queue" do
    LogLineParserWorker.sidekiq_options_hash['queue'].should eq 'logs'
  end

  describe "#perform" do
    let(:line) { 'line foo' }
    before { LogLineParser.stub(:new) { parsed_line } }

    context "with data request line" do
      let(:parsed_line) { mock(LogLineParser,
        site_token: 'site_token',
        timestamp:  1366466401,
        user_agent: 'user agent',
        ip:         '176.206.33.0',
        data: [
          { 'e' => 'al', 'foo' => 'bar' },
          { 'e' => 'l', 'foo' => 'bar' }],
        data_request?: true)
      }

      it "delays stats handling for each event" do
        StatsHandlerWorker.should_receive(:perform_async).with('al', 'foo' => 'bar', 's' => 'site_token', 't' => 1366466401, 'ua' => 'user agent', 'ip' => '176.206.33.0')
        StatsHandlerWorker.should_receive(:perform_async).with('l',  'foo' => 'bar', 's' => 'site_token', 't' => 1366466401, 'ua' => 'user agent', 'ip' => '176.206.33.0')
        worker.perform(line)
      end
    end

    context "with non data request line" do
      let(:parsed_line) { mock(LogLineParser, data_request?: false) }

      it "does nothing" do
        StatsHandlerWorker.should_not_receive(:perform_async)
        worker.perform(line)
      end
    end
  end
end
