require 'spec_helper'

describe "Logs creation", :slow, :redis do
  let(:scaler) { double(Autoscaler::HerokuScaler, :workers= => true) }
  before {
    EdgecastWrapper.stub(:remove_log_file) { true }
    Autoscaler::HerokuScaler.stub(:new) { scaler }
    LogsCreatorWorker.jobs.clear
    LogReaderWorker.jobs.clear
    LogLineParserWorker.jobs.clear
    StatsHandlerWorker.jobs.clear
  }

  it "fetches logs, store, read and parse them" do
    LogsCreatorWorker.perform_async
    LogsCreatorWorker.drain
    Log.should have(2).logs
    LogReaderWorker.should have(2).jobs
    LogReaderWorker.drain
    LogLineParserWorker.should have(1).jobs
    LogLineParserWorker.drain
    StatsHandlerWorker.should have(2).jobs
  end
end
