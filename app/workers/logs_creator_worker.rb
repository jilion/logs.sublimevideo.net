require 'sidekiq'

class LogsCreatorWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'logs'

  def perform
    LogsCreator.shift_and_create_logs
  end
end
