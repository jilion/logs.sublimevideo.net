source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '4.0.0'

gem 'pg'
gem 'oj'

gem 'carrierwave'
gem 'fog'

gem 'sidekiq'
gem 'sidekiq-limit_fetch'
gem 'autoscaler'

gem 'honeybadger'
gem 'librato-rails'
gem 'librato-sidekiq'
gem 'newrelic_rpm'

gem 'net-sftp'
gem 'rescue_me'

group :development, :test do
  gem 'rspec-rails'
  gem 'dotenv-rails'
end

group :development do
  gem 'annotate', require: false
  gem 'foreman', require: false

  # Guard
  gem 'ruby_gntp', require: false
  gem 'guard-rspec', require: false
end

group :test do
  gem 'rspec'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
end
