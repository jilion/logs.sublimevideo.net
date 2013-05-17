require 'spec_helper'

describe "Logs creation", :slow do
  before { EdgecastWrapper.stub(:remove_log_file) { true } }

  it "fetches logs, store, read and parse them" do
    LogsCreatorWorker.perform_async
    LogsCreatorWorker.drain
    Log.should have(2).logs
    LogReaderWorker.should have(2).jobs
    LogReaderWorker.drain
    LogLineParserWorker.should have_at_least(35707).jobs
    LogLineParserWorker.drain
    StatsHandlerWorker.should have(0).jobs
  end
end
