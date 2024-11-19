if ENV['REDIS_URL'].present?
  uri = URI.parse(ENV['REDIS_URL'])
  REDIS = Redis.new(
    :url => ENV['REDIS_URL'],
    :ssl => true,
    :ssl_params => { 
      :verify_mode => OpenSSL::SSL::VERIFY_NONE 
    }
  )
else
  REDIS = Redis.new
end
