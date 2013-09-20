require 'spec_helper'

describe LogsCreatorWorker do
  let(:worker) { LogsCreatorWorker.new }

  it "delays job in stats queue" do
    expect(LogsCreatorWorker.sidekiq_options_hash['queue']).to eq 'logs'
  end

  describe "#perform" do
    it "calls shift_and_create_logs on LogsCreator" do
      expect(LogsCreator).to receive(:shift_and_create_logs)
      worker.perform
    end
  end
end
