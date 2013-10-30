source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '4.0.0'

gem 'pg'
gem 'oj'

gem 'carrierwave', require: ['carrierwave', 'carrierwave/orm/activerecord']
gem 'fog'
gem 'unf'

gem 'sidekiq'

gem 'honeybadger'
gem 'librato-rails'
gem 'librato-sidekiq'

gem 'net-sftp', require: 'net/sftp'
gem 'rescue_me'

group :staging, :production do
  gem 'newrelic_rpm'
  gem 'newrelic-redis'
  gem 'rails_12factor'
end

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
