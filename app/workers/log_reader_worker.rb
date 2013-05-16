require 'sidekiq'

class LogReaderWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'logs-reader'

  attr_accessor :log, :index

  def perform(log_id)
    @log   = Log.find(log_id)
    _log_lines do |line|
      LogLineParserWorker.perform_async(line)
    end
    log.touch(:read_at)
  ensure
    log.update_attribute(:read_lines, index)
  end

  private

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
