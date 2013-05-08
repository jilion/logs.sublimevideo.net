require 'sidekiq'

class LogReaderWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'logs'

  def perform(log_id)
    # TODO
  end
end
