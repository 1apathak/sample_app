# config/initializers/carrierwave.rb
 
CarrierWave.configure do |config|
  config.fog_credentials = {
    # Configuration for Amazon S3 should be made available through an Environment variable.
    # For local installations, export the env variable through the shell OR
    # if using Passenger, set an Apache environment variable.
    #
    # In Heroku, follow http://devcenter.heroku.com/articles/config-vars
    #
    # $ heroku config:add S3_KEY=AKIAITLIRY4ZBBUF7WVQ S3_SECRET=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 S3_REGION=eu-west-1 S3_ASSET_URL=http://liftmuse.s3-us-west-1.amazonaws.com S3_BUCKET_NAME=liftmuse
 
    # Configuration for Amazon S3
    :provider              => 'AWS',
    :aws_access_key_id     => ENV['S3_KEY'],
    :aws_secret_access_key => ENV['S3_SECRET'],
   # :region                => ENV['S3_REGION']
  }
 
  config.fog_directory    = ENV['S3_BUCKET_NAME']
  config.fog_public     = true                                   # optional, defaults to true
 # config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
 # config.asset_host     = ENV['S3_ASSET_URL']         # optional, defaults to nil

  # For testing, upload files to local `tmp` folder.
  if Rails.env.test? || Rails.env.cucumber?
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  else
    config.storage = :fog
  end
 
  config.cache_dir = "#{Rails.root}/tmp/uploads"                  # To let CarrierWave work on heroku
 
  
  #config.s3_access_policy = :public_read                          # Generate http:// urls. Defaults to :authenticated_read (https://)
  #config.fog_host         = "#{ENV['S3_ASSET_URL']}/#{ENV['S3_BUCKET_NAME']}"
end