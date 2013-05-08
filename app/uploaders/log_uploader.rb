class LogUploader < CarrierWave::Uploader::Base

  def store_dir
    Rails.env.test? ? "uploads/#{model.provider}" : model.provider
  end

end
