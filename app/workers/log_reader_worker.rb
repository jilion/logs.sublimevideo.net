require 'zlib'

class LogReaderWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'logs'

  attr_accessor :log, :index

  def perform(log_id)
    @log = Log.find(log_id)
    _with_blocked_queue { _read_log_and_delay_gif_requests_parsing }
  end

  private

  def _with_blocked_queue
    Sidekiq::Queue['logs'].block
    yield
    Sidekiq::Queue['logs'].unblock
  end

  def _read_log_and_delay_gif_requests_parsing
    _gif_request_lines { |line| LogLineParserWorker.perform_async(line) }
    log.touch(:read_at)
  ensure
    log.update_attribute(:read_lines, index)
  end

  def _gif_request_lines
    @index = -1 # skip header
    _gzip_lines do |line|
      if index >= log.read_lines && _gif_request?(line)
        yield(line)
      end
      @index += 1
    end
  end

  def _gif_request?(line)
    line.include?('//cdn.sublimevideo.net/_.gif?i=')
  end

  def _gzip_lines
    log.log_file do |log_file|
      gz = Zlib::GzipReader.new(log_file, encoding: 'iso-8859-1')
      gz.each_line { |line| yield(line) }
    end
  end
end
