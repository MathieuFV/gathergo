# Initialisation du service Google Places
service = GooglePlacesService.new(GOOGLE_PLACES_API_KEY)
result = service.fetch_place_details("ancelle")

p result[:name]

p WikipediaService.new(result[:name]).fetch_wikipedia_summary


# marin = User.where(first_name: "Marin").first

# origin = { lat: 45.904427, lng: 6.423353 }
# destination = { lat: marin.latitude, lng: marin.longitude }
# distance_info = service.fetch_distance(origin, destination)

# puts distance_info
