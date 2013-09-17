class Log < ActiveRecord::Base
  mount_uploader :file, LogUploader

  validates :name, :provider, :file, presence: true

  def log_file
    LogFile.open!(name, file.file.read) { |log_file| yield(log_file) }
  end

end

# == Schema Information
#
# Table name: logs
#
#  created_at :datetime
#  file       :string(255)
#  id         :integer          not null, primary key
#  name       :string(255)
#  provider   :string(255)
#  read_at    :datetime
#  read_lines :integer          default(0)
#  updated_at :datetime
#
# Indexes
#
#  index_logs_on_name_and_provider  (name,provider) UNIQUE
#

