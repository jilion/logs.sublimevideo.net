class LogsCreator

  def self.shift_and_create_logs
    EdgecastWrapper.logs_filename.each do |filename|
      log = _create_log(filename)
      LogReaderWorker.perform_async(log.id)
      _remove_log_file(filename)
    end
  end

  private

  def self._create_log(filename)
    log_file = EdgecastWrapper.log_file(filename)
    Log.create!(name: filename, provider: 'edgecast', file: log_file)
  end

  def self._remove_log_file(filename)
    EdgecastWrapper.remove_log_file(filename)
  end
end