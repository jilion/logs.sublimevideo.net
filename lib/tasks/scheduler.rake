namespace :scheduler do
  desc "Shift and create logs"
  task :logs_creator_worker => :environment do
    LogsCreatorWorker.perform_async
  end
end
