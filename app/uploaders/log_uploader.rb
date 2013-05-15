class LogUploader < CarrierWave::Uploader::Base

  def store_dir
    Rails.env.test? ? "uploads/logs/#{model.provider}" : "logs/#{model.provider}"
  end

end
