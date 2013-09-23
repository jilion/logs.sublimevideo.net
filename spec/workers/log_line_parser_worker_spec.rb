require 'spec_helper'

describe LogLineParserWorker do
  let(:worker) { LogLineParserWorker.new }

  it "delays job in stats queue" do
    expect(LogLineParserWorker.sidekiq_options_hash['queue']).to eq 'logs-parser'
  end

  describe "#perform" do
    let(:line) { 'line foo' }
    before { LogLineParser.stub(:new) { parsed_line } }

    context "with data request line" do
      let(:parsed_line) { double(LogLineParser,
        site_token: 'site_token',
        timestamp:  1366466401,
        user_agent: 'user agent',
        ip:         '176.206.33.0',
        data: [
          { 'e' => 'al', 'sa' => '1', 'foo' => 'bar' },
          { 'e' => 'l', 'foo' => 'bar' }],
        data_request?: true)
      }

      it "delays stats handling for each event" do
        expect(StatsWithAddonHandlerWorker).to receive(:perform_async).with('al', 'sa' => '1', 'foo' => 'bar', 's' => 'site_token', 't' => 1366466401, 'ua' => 'user agent', 'ip' => '176.206.33.0')
        expect(StatsWithoutAddonHandlerWorker).to receive(:perform_async).with('l',  'foo' => 'bar', 's' => 'site_token', 't' => 1366466401, 'ua' => 'user agent', 'ip' => '176.206.33.0')
        worker.perform(line)
      end
    end

    context "with non data request line" do
      let(:parsed_line) { double(LogLineParser, data_request?: false) }

      it "does nothing" do
        expect(StatsWithAddonHandlerWorker).to_not receive(:perform_async)
        expect(StatsWithoutAddonHandlerWorker).to_not receive(:perform_async)
        worker.perform(line)
      end
    end
  end
end
