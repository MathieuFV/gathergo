# Initialisation du service Google Places
service = GooglePlacesService.new(GOOGLE_PLACES_API_KEY)
result = service.fetch_place_details("La clusaz,,, ")

# p result

# essai = Geocoder.search("Corbel, France")
# p essai


# marin = User.where(first_name: "Marin").first

# origin = { lat: result[:latitude], lng: result[:longitude] }
# destination = { lat: marin.latitude, lng: marin.longitude }
# distance_info = service.fetch_distance(origin, destination)

# distance_info[:duration_text] = distance_info[:duration_text].gsub(/\s?hour(s)?\b/, "h")

# puts distance_info


# Vérification geo searching wikipedi

# Variables pour latitude et longitude
latitude = result[:latitude]
longitude = result[:longitude]
radius = 1000 # Rayon de recherche en mètres

# Construire l'URL avec les coordonnées
url = URI("https://fr.wikipedia.org/w/api.php?action=query&list=geosearch&gscoord=#{latitude}|#{longitude}&gslimit=10&format=json&gsradius=#{radius}")

# Envoyer la requête HTTP
response = Net::HTTP.get(url)

# Parser la réponse JSON
json = JSON.parse(response)

# Afficher les résultats
if json["query"] && json["query"]["geosearch"]
  page_id = json["query"]["geosearch"].first["pageid"].to_i
  # p page_id
else
  puts "Aucun résultat trouvé"
end

# Fetch page Wikipedia
api_url = URI("https://fr.wikipedia.org/w/api.php")

# Définition des paramètres pour obtenir un extrait complet et les coordonnées
params = {
  action: 'query',
  format: 'json',
  prop: 'extracts',
  exintro: 1,
  explaintext: 1,
  redirects: 1,           # Redirige vers une orthographe plausible
  pageids: page_id,
  exsectionformat: 'plain' # Format des sections en texte brut
}

# Construction de la requête avec les paramètres
api_url.query = URI.encode_www_form(params)

# Appel à l'API avec le bon titre
summary_response = Net::HTTP.get(api_url)
# Parser la réponse JSON
json = JSON.parse(summary_response)

# p json

# VERIFICATION GEOCODING
# address = "Corbel"
# api_key = "AIzaSyAxUJHrII6I6PgRntLWDJOMadY77YJi0Is"

# encoded_address = URI.encode_www_form_component(address)
# url = URI("https://maps.googleapis.com/maps/api/geocode/json?address=#{encoded_address}&key=#{api_key}")

# response = Net::HTTP.get(url)
# json = JSON.parse(response)
# if json["status"] == "OK"
#   puts json["results"].first
# else
#   puts "Aucun résultat trouvé"
# end
