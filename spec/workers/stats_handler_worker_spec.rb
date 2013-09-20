require 'spec_helper'

describe StatsHandlerWorker do
  it "delays job in stats queue" do
    expect(StatsHandlerWorker.sidekiq_options_hash['queue']).to eq 'stats'
  end
end
