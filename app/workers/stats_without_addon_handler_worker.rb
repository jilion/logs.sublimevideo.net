require 'sidekiq'

class StatsWithoutAddonHandlerWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats-slow'

  def perform(event_key, data)
    # method handled elsewhere
  end
end
