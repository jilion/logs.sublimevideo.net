worker: env LIBRATO_AUTORUN=1 DB_POOL=10 bundle exec sidekiq -c 10 -t 10 -q logs
scheduler: bundle exec rake scheduler:logs_creator_worker
