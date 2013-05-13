require 'zlib'
require 'sidekiq'

class LogLineParserWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'logs'

  attr_accessor :log

  def perform(line)
  end

end
