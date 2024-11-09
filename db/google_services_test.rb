places_service = GooglePlacesService.new(GOOGLE_PLACES_API_KEY)

result = places_service.fetch_place_details("Méribel")

p result[:photo_url].size
