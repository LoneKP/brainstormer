if ENV['REDIS_TEMPORARY_URL'].present?
  uri = URI.parse(ENV['REDIS_TEMPORARY_URL'])
  REDIS = Redis.new(
    host: uri.host, 
    port: uri.port, 
    password: uri.password,
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  )
else
  REDIS = Redis.new
end