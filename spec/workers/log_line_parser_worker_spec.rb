require 'spec_helper'

describe LogLineParserWorker do
  let(:worker) { LogLineParserWorker.new }
  let(:parsed_line) { mock(LogLineParser,
    site_token: 'site_token',
    timestamp:  1366466401,
    user_agent: 'user agent',
    ip:         '176.206.33.0',
    data: [
      { 'e' => 'al', 'foo' => 'bar' },
      { 'e' => 'l', 'foo' => 'bar' }
    ]) }

  describe "#perform" do
    let(:line) { 'line foo' }
    before { LogLineParser.stub(:new) { parsed_line } }

    it "delays stats handling for each event" do
      StatsHandlerWorker.should_receive(:perform_async).with('al', 'foo' => 'bar', 's' => 'site_token', 't' => 1366466401, 'ua' => 'user agent', 'ip' => '176.206.33.0')
      StatsHandlerWorker.should_receive(:perform_async).with('l',  'foo' => 'bar', 's' => 'site_token', 't' => 1366466401, 'ua' => 'user agent', 'ip' => '176.206.33.0')
      worker.perform(line)
    end
  end
end
