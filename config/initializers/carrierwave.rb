require 'carrierwave'
require 'carrierwave/orm/activerecord'

module CarrierWave
  class << self
    def fog_configuration
      configure do |config|
        config.cache_dir       = Rails.root.join('tmp/uploads')
        config.storage         = :fog
        config.fog_public      = false
        config.fog_directory   = S3Wrapper.bucket
        config.fog_attributes  = {}
        config.fog_credentials = {
          provider:              'AWS',
          aws_access_key_id:     S3Wrapper.access_key_id,
          aws_secret_access_key: S3Wrapper.secret_access_key,
          region:                'us-east-1'
        }
      end
    end

    def file_configuration
      configure do |config|
        config.storage           = :file
        config.enable_processing = false
      end
    end
  end
end

case Rails.env
when 'production', 'staging', 'development'
  CarrierWave.fog_configuration
when 'test'
  CarrierWave.file_configuration
end
