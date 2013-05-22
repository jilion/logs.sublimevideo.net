worker: bundle exec sidekiq -c 25 -t 10 -q logs-reader -q logs
scheduler: bundle exec rake scheduler:logs_creator_worker
