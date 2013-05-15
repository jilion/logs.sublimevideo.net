require 'zlib'
require 'sidekiq'

class LogLineParserWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'logs'

  attr_accessor :parsed_line

  def perform(line)
    @parsed_line = LogLineParser.new(line)
    return unless parsed_line.data_request?

    _events do |event_key, data|
      StatsHandlerWorker.perform_async(event_key, data)
    end
  end

  private

  def _events
    parsed_line.data.each do |data|
      event_key = data.delete('e')
      data.merge!(_parsed_line_attributes)
      yield(event_key, data)
    end
  end

  def _parsed_line_attributes
    { 's'  => parsed_line.site_token,
      't'  => parsed_line.timestamp,
      'ua' => parsed_line.user_agent,
      'ip' => parsed_line.ip }
  end
end
