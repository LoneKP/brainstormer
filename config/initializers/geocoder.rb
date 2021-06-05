Geocoder.configure(
  ip_lookup: :geoip2,
  geoip2: {
    file: Rails.root.join("lib", "geocoder", "GeoLite2-City.mmdb")
  }
)