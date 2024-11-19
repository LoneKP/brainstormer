if ENV['REDIS_URL'].present?
  uri = URI.parse(ENV['REDIS_URL'])
  REDIS = Redis.new(
    host: uri.host, 
    port: uri.port, 
    password: uri.password,
    ssl: true
  )
else
  REDIS = Redis.new
end
