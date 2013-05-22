worker: bundle exec sidekiq -c 25 -t 10 -q logs -q logs-parser
scheduler: bundle exec rake scheduler:logs_creator_worker
