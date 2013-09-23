require 'spec_helper'

describe "Logs creation", :slow, :redis do
  let(:scaler) { double(Autoscaler::HerokuScaler, :workers= => true) }
  before {
    EdgecastWrapper.stub(:remove_log_file) { true }
    Autoscaler::HerokuScaler.stub(:new) { scaler }
    LogsCreatorWorker.jobs.clear
    LogReaderWorker.jobs.clear
    LogLineParserWorker.jobs.clear
    StatsWithoutAddonHandlerWorker.jobs.clear
  }

  it "fetches logs, store, read and parse them" do
    LogsCreatorWorker.perform_async
    LogsCreatorWorker.drain
    expect(Log).to have(2).logs
    expect(LogReaderWorker).to have(2).jobs
    LogReaderWorker.drain
    expect(LogLineParserWorker).to have(1).jobs
    LogLineParserWorker.drain
    expect(StatsWithoutAddonHandlerWorker).to have(2).jobs
  end
end
