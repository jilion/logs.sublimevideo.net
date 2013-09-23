require 'spec_helper'

describe StatsWithoutAddonHandlerWorker do
  it "delays job in stats queue" do
    expect(StatsWithoutAddonHandlerWorker.sidekiq_options_hash['queue']).to eq 'stats-slow'
  end
end
