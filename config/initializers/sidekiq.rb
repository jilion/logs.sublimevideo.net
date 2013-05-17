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

if ENV['HEROKU_APP']
  require 'autoscaler/sidekiq'
  require 'autoscaler/heroku_scaler'
  heroku = Autoscaler::HerokuScaler.new('worker')
  heroku_reader = Autoscaler::HerokuScaler.new('worker_reader')

  Sidekiq.configure_client do |config|
    config.client_middleware do |chain|
      chain.add Autoscaler::Sidekiq::Client, 'logs' => heroku, 'logs-reader' => heroku_reader
    end
  end

  Sidekiq.configure_server do |config|
    config.client_middleware do |chain|
      chain.add Autoscaler::Sidekiq::Client, 'logs' => heroku, 'logs-reader' => heroku_reader
    end
    config.server_middleware do |chain|
      chain.add Autoscaler::Sidekiq::Server, heroku, 10, %w[logs]
      chain.add Autoscaler::Sidekiq::Server, heroku_reader, 10, %w[logs-reader]
    end
  end
end
