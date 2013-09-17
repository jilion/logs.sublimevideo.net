class EdgecastWrapper
  RSYNC_SERVER = 'rsync.lax.edgecastcdn.net'
  LOGS_PATH = ENV['EDGECAST_LOGS_PATH']

  def self.logs_filename
    rescue_and_retry(5) { _sftp.dir.glob(LOGS_PATH, '*.gz').map(&:name).sort }
  end

  def self.log_file(filename)
    rescue_and_retry(5) do
      sftp_file = _sftp.file.open(_log_path(filename), "r")
      LogFile.open!(filename, sftp_file.read) { |log_file| yield(log_file) }
    end
  end

  def self.remove_log_file(filename)
    rescue_and_retry(5) { _sftp.remove!(_log_path(filename)) }
  end

  private

  def self._log_path(filename)
    "#{LOGS_PATH}/#{filename}"
  end

  def self._sftp
    Net::SFTP.start(RSYNC_SERVER, ENV['EDGECAST_USER'], password: ENV['EDGECAST_PASSWORD'], paranoid: false)
  end
end
