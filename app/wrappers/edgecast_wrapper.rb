require 'tempfile'
require 'net/sftp'
require 'configurator'

class EdgecastWrapper
  include Configurator

  config_file 'edgecast.yml'
  config_accessor :rsync_server, :user, :password, :logs_path

  def self.logs_filename
    _sftp.dir.foreach(logs_path) do |log_file|
      next if log_file.name.in? ['.', '..']
      yield(log_file.name)
    end
  end

  def self.log_file(filename)
    _sftp.file.open(_log_path(filename), "r")
  end

  def self.remove_log_file(filename)
    _sftp.remove!(_log_path(filename))
  end

  private

  def self._log_path(filename)
    "#{logs_path}/#{filename}"
  end

  def self._sftp
    @sftp ||= Net::SFTP.start(rsync_server, user, password: password, paranoid: false)
  end
end
