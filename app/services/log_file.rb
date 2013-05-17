class LogFile < File
  attr_accessor :path

  def initialize(name, content)
    @path = Rails.root.join('tmp', name)
    super(path, 'w+')
    write(content.encode!('UTF-8', 'UTF-8', invalid: :replace))
    rewind
  end

  def self.open!(name, content)
    log_file = new(name, content)
    result = yield(log_file)
    log_file.delete
    result
  end

  def delete
    File.delete(path)
  end
end
