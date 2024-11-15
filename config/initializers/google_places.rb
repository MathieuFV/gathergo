GOOGLE_GEOCODING_API_KEY = ENV['GOOGLE_GEOCODING_API_KEY']
unless GOOGLE_GEOCODING_API_KEY
  Rails.logger.warn 'Google Places API key not found in environment variables'
end
