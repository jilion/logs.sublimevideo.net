require 'multi_json'
require 'cgi'

class LogLineParser

  REGEX = %r{^
    (\d*)\s  # timestamp
    (\d*)\s  # time_taken
    (\S*)\s  # client ip
    (\d*)\s  # filesize
    (\S*)\s  # server ip
    (\d*)\s  # port
    (\S*)\s  # status
    (\d*)\s  # response bytes
    (\S*)\s  # method
    (\S*)\s  # uri-stem
    (\S*)\s  # uri-query
    (\d*)\s  # duration
    (\d*)\s  # request bytes
    "(.*)"\s # referrer
    "(.*)"\s # user agent
    (\S*)\s  # customer id
    "(.*)"   # x-ec_custom-1
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
    _scan[8]
  end

  def uri_stem
    _scan[9]
  end

  def uri_query
    _scan[10]
  end

  def user_agent
    _scan[14]
  end

  def data_request?
    uri_stem.include?('//cdn.sublimevideo.net/_.gif') && method == 'GET'
  end

  def site_token
    _params['s'].first
  end

  def data
    MultiJson.load(_params['d'].first)
  end

  private

  def _params
    @params ||= CGI::parse(uri_query)
  end

  def _scan
    @scan ||= line.scan(REGEX).flatten
  end

end
