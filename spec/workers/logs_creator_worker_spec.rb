require 'spec_helper'

describe LogsCreatorWorker do
  let(:worker) { LogsCreatorWorker.new }

  it "delays job in stats queue" do
    LogsCreatorWorker.sidekiq_options_hash['queue'].should eq 'logs'
  end

  describe "#perform" do
    it "calls shift_and_create_logs on LogsCreator" do
      LogsCreator.should_receive(:shift_and_create_logs)
      worker.perform
    end
  end
end
