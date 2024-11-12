# Initialisation du service Google Places
service = GooglePlacesService.new(GOOGLE_PLACES_API_KEY)
marin = User.where(first_name: "Marin").first

origin = { lat: 45.904427, lng: 6.423353 }
destination = { lat: marin.latitude, lng: marin.longitude }
distance_info = service.fetch_distance(origin, destination)

puts distance_info
