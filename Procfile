worker: bundle exec sidekiq -c 25 -t 10 -q logs
worker_reader: bundle exec sidekiq -c 1 -t 300 -q logs-reader
scheduler: bundle exec rake scheduler:logs_creator_worker
