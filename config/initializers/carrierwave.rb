if Rails.env.development? || Rails.env.test?
  CarrierWave.configure do |config|
    config.storage    = :file
    config.enable_processing = false if Rails.env.test?
  end
else
  CarrierWave.configure do |config|
    config.storage    = :aws
    config.aws_bucket = JSON.parse(ENV['VCAP_SERVICES'])['aws-s3-bucket'][0]['credentials']['bucket_name']
    config.aws_acl    = 'private'

    config.aws_authenticated_url_expiration = 60

    # Set custom options such as cache control to leverage browser caching.
    # You can use either a static Hash or a Proc.
    config.aws_attributes = -> { {
      expires: 1.minute.from_now.httpdate,
      cache_control: "max-age=#{1.minute.to_i}"
    } }

    config.aws_credentials = {
      region: JSON.parse(ENV['VCAP_SERVICES'])['aws-s3-bucket'][0]['credentials']['aws_region'],
      access_key_id: JSON.parse(ENV['VCAP_SERVICES'])['aws-s3-bucket'][0]['credentials']['aws_access_key_id'],
      secret_access_key: JSON.parse(ENV['VCAP_SERVICES'])['aws-s3-bucket'][0]['credentials']['aws_secret_access_key']
    }
  end
end
