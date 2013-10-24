class LogLineParserWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'logs-parser'

  attr_accessor :parsed_line

  def perform(line)
    @parsed_line = LogLineParser.new(line)
    return unless parsed_line.data_request?

    _events do |event_key, data|
      _increment_metrics(event_key)
      _delay_stats_handling(event_key, data)
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

  def _delay_stats_handling(event_key, data)
    stats_handler_class = data['sa'] ? StatsWithAddonHandlerWorker : StatsWithoutAddonHandlerWorker
    stats_handler_class.perform_async(event_key, data)
  end

  def _increment_metrics(event_key)
    Librato.increment "logs.event_type", source: event_key
    Librato.increment "logs.player_version", source: parsed_line.player_version
    case event_key
    when 'l' then Librato.increment "temp.loads.#{parsed_line.player_version}", source: 'new'
    when 's' then Librato.increment "temp.starts.#{parsed_line.player_version}", source: 'new'
    end
  end

end
