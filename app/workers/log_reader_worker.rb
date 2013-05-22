require 'sidekiq'

class LogReaderWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'logs'

  attr_accessor :log, :scaler, :index

  def perform(log_id)
    @log = Log.find(log_id)
    @scaler = Autoscaler::HerokuScaler.new
    _with_blocked_queue { _read_log }
  end

  private

  def _with_blocked_queue
    Sidekiq::Queue['logs'].block
    scaler.workers = 1
    yield
    scaler.workers = 4
    Sidekiq::Queue['logs'].unblock
  end

  def _read_log
    _log_lines do |line|
      LogLineParserWorker.perform_async(line)
    end
    log.touch(:read_at)
  ensure
    log.update_attribute(:read_lines, index)
  end

  def _log_lines
    @index = -1 # skip header
    _gzip_lines do |line|
      yield(line) if index >= log.read_lines
      @index += 1
    end
  end

  def _gzip_lines
    log.log_file do |log_file|
      gz = Zlib::GzipReader.new(log_file, encoding: 'iso-8859-1')
      gz.each_line { |line| yield(line) }
    end
  end
end
