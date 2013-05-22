require 'sidekiq'

Sidekiq.configure_server do |config|
  if database_url = ENV['DATABASE_URL']
    ENV['DATABASE_URL'] = "#{database_url}?pool=30"
    ActiveRecord::Base.establish_connection
  end
end

Sidekiq.configure_client do |config|
  config.redis = { size: 2 } # for web dyno
end

if Rails.env.production?
  require 'sidekiq/limit_fetch'
  require 'autoscaler/sidekiq'
  require 'autoscaler/heroku_scaler'
  scaler = Autoscaler::HerokuScaler.new

  module Autoscaler
    module Sidekiq
      class CustomClient
        def initialize(scalers)
          @scalers = scalers
        end
        def call(worker_class, item, queue)
          @scalers[queue] && @scalers[queue].workers = 5
          yield
        end
      end
    end
  end

  Sidekiq.configure_client do |config|
    config.client_middleware do |chain|
      chain.add Autoscaler::Sidekiq::Client, 'logs' => scaler
      chain.add Autoscaler::Sidekiq::CustomClient, 'logs-parser' => scaler
    end
  end

  Sidekiq.configure_server do |config|
    config.client_middleware do |chain|
      chain.add Autoscaler::Sidekiq::Client, 'logs' => scaler
      chain.add Autoscaler::Sidekiq::CustomClient, 'logs-parser' => scaler
    end
    config.server_middleware do |chain|
      chain.add Autoscaler::Sidekiq::Server, scaler, 10, %w[logs logs-parser]
    end
  end
end
