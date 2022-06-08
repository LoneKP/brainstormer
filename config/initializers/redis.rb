if ENV['REDIS_URL'].present?
  puts "redis url is present: #{ENV['REDIS_URL']}"
  uri = URI.parse(ENV['REDIS_URL'])
  REDIS = Redis.new(host: uri.host, port: uri.port, password: uri.password)
else
  puts "redis url is not present"
  REDIS = Redis.new
end
