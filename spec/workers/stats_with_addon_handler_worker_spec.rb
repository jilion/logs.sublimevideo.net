require 'spec_helper'

describe StatsWithAddonHandlerWorker do
  it "delays job in stats queue" do
    expect(StatsWithAddonHandlerWorker.sidekiq_options_hash['queue']).to eq 'stats'
  end
end
