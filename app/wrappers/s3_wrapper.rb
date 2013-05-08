require 'configurator'

module S3Wrapper
  include Configurator

  config_file 's3.yml'
  config_accessor :access_key_id, :secret_access_key, :bucket
end
