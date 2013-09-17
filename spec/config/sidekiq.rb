require 'sidekiq'
require 'sidekiq/testing'

Sidekiq.logger.level = Logger::WARN

RSpec.configure do |config|
  config.before :each, redis: true do
    $redis = Redis.new
    $redis.flushall
  end
end
