require 'spec_helper'

describe StatsHandlerWorker do
  it "delays job in stats queue" do
    StatsHandlerWorker.sidekiq_options_hash['queue'].should eq 'stats'
  end
end
