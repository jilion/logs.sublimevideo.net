require 'autoscaler/sidekiq'
require 'autoscaler/heroku_scaler'

Sidekiq.configure_client do |config|
  config.redis = { size: 2 } # for web dyno
end

if Rails.env.production?
  scaler = Autoscaler::HerokuScaler.new

  Sidekiq.configure_client do |config|
    config.client_middleware do |chain|
      chain.add Autoscaler::Sidekiq::Client, 'logs' => scaler, 'logs-parser' => scaler
    end
  end

  Sidekiq.configure_server do |config|
    config.client_middleware do |chain|
      chain.add Autoscaler::Sidekiq::Client, 'logs' => scaler, 'logs-parser' => scaler
    end
    config.server_middleware do |chain|
      chain.add Autoscaler::Sidekiq::Server, scaler, 10, %w[logs logs-parser]
    end
  end
end
