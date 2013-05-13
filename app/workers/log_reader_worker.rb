require 'zlib'
require 'sidekiq'

class LogReaderWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'logs'

  attr_accessor :log, :index

  def perform(log_id)
    @log = Log.find(log_id)
    _log_lines do |line|
      next if index < log.parsed_lines
      LogLineParserWorker.perform_async(line)
    end
  ensure
    log.update_attribute(:parsed_lines, index)
  end

  private

  def _log_lines
    @index = 0
    gz = Zlib::GzipReader.new(log.log_file)
    gz.each_line do |line|
      yield(line)
      @index += 1
    end
  end

end
