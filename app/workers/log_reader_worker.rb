require 'sidekiq'

class LogReaderWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'logs'

  attr_accessor :log, :index

  def perform(log_id)
    @log = Log.find(log_id)
    _log_lines do |line|
      next if index < log.read_lines
      LogLineParserWorker.perform_async(line)
    end
    log.touch(:read_at)
  ensure
    log.update_attribute(:read_lines, index)
  end

  private

  def _log_lines
    @index = -1 # skip header
    gz = Zlib::GzipReader.new(log.log_file)
    gz.each_line do |line|
      line.gsub!(/\n/, '')
      yield(line)
      @index += 1
    end
  end
end
