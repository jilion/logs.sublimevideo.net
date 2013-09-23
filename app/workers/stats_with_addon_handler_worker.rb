require 'sidekiq'

class StatsWithAddonHandlerWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  def perform(event_key, data)
    # method handled elsewhere
  end
end
