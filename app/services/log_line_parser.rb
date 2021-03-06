require 'cgi'

class LogLineParser

  REGEX = %r{^
    (\d*)\s  # timestamp
    (\d*)\s  # time_taken
    (\S*)\s  # client ip
    (\S*)\s  # filesize
    (\S*)\s  # server ip
    (\d*)\s  # port
    (\S*)\s  # status
    (\d*)\s  # response bytes
    (\S*)\s  # method
    (\S*)\s  # uri-stem
    -\s  # uri-query
    (\d*)\s  # duration
    (\d*)\s  # request bytes
    "(.*)"\s # referrer
    "(.*)"\s # user agent
    (\S*)    # customer id
  }x

  attr_accessor :line

  def initialize(line)
    @line = line
  end

  def timestamp
    _scan[0].to_i
  end

  def ip
    _scan[2]
  end

  def status
    _scan[6].split('/').last.to_i
  end

  def method
    _scan[8].upcase
  end

  def uri_stem
    _scan[9]
  end

  def user_agent
    _scan[13]
  end

  def data_request?
    @data_request ||= uri_stem.include?('//cdn.sublimevideo.net/_.gif') && %w[GET HEAD].include?(method) && _params.key?('s')
  end

  def site_token
    _params['s'].first
  end

  def player_version
    _params['v'].first || 'none'
  end

  def data
    json = _params['d'].first
    MultiJson.load(json)
  rescue => ex
    Honeybadger.notify_or_ignore(ex, context: { 'data' => json })
    []
  end

  private

  def _params
    @params ||= CGI::parse(uri_stem)
  end

  def _scan
    @scan ||= line.scan(REGEX).flatten
  end

end
