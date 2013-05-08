source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '4.0.0.rc1'

gem 'pg'
gem 'sidekiq'
gem 'fog'
gem 'oj'
gem 'configurator', github: 'jilion/configurator'

gem 'honeybadger'
gem 'librato-rails', github: 'librato/librato-rails', branch: 'feature/rack_first'
gem 'librato-sidekiq'
gem 'newrelic_rpm'

gem 'net-sftp'

group :development, :test do
  gem 'rspec-rails'
end

group :development do
  gem 'annotate'
  gem 'foreman'

  # Guard
  gem 'ruby_gntp'
  gem 'guard-rspec'
end

group :test do
  gem 'rspec'
  gem 'shoulda-matchers'
end
