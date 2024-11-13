# Initialisation du service Google Places
service = GooglePlacesService.new(GOOGLE_PLACES_API_KEY)
result = service.fetch_place_details("mykonos")

p result

marin = User.where(first_name: "Marin").first

origin = { lat: result[:latitude], lng: result[:longitude] }
destination = { lat: marin.latitude, lng: marin.longitude }
distance_info = service.fetch_distance(origin, destination)

distance_info[:duration_text] = distance_info[:duration_text].gsub(/\s?hour(s)?\b/, "h")

puts distance_info
