class Log < ActiveRecord::Base
  mount_uploader :file, LogUploader

  validates :name, :provider, :file, presence: true

  def log_file
    file.file.to_file
  end
end

# == Schema Information
#
# Table name: logs
#
#  created_at   :datetime
#  file         :string(255)
#  id           :integer          not null, primary key
#  name         :string(255)
#  parsed_at    :datetime
#  parsed_lines :integer          default(0)
#  provider     :string(255)
#  updated_at   :datetime
#
# Indexes
#
#  index_logs_on_name_and_provider  (name,provider) UNIQUE
#

