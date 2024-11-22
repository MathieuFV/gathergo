def haversine_distance(lat1, lon1, lat2, lon2)
  # Rayon de la Terre en kilomètres
  earth_radius = 6371.0

  # Conversion des degrés en radians
  dlat = (lat2 - lat1) * Math::PI / 180
  dlon = (lon2 - lon1) * Math::PI / 180

  # Calcul intermédiaire
  a = Math.sin(dlat / 2) ** 2 +
      Math.cos(lat1 * Math::PI / 180) * Math.cos(lat2 * Math::PI / 180) *
      Math.sin(dlon / 2) ** 2
  c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

  # Distance en km
  earth_radius * c
end

def essai_google_wiki(destination_name)
  p "Essai #{destination_name} "
  # Initialisation du service Google Places
  service = GooglePlacesService.new(ENV['GOOGLE_GEOCODING_API_KEY'])
  result = service.fetch_place_details(destination_name)

  # Variables pour latitude et longitude
  google_lat = result[:latitude]
  google_lon = result[:longitude]

  # p "Google lat: #{google_lat} - long: #{google_lon}"

  # essai = Geocoder.search("Corbel, France")
  # p essai

  # Récupération wikipedia
  wikipedia = WikipediaService.new(destination_name, "en")
  wikipedia_info = wikipedia.fetch_wikipedia_summary

  if wikipedia_info.present?

    # Vérification de la page wikipédia trouvée (comparaison des coordonnées)
    if wikipedia_info[:coordinates]
      wiki_lat = wikipedia_info[:coordinates].first["lat"]
      wiki_lon = wikipedia_info[:coordinates].first["lon"]

      # Comparaison des deux coordonnées
      # p haversine_distance(google_lat, google_lon, wiki_lat, wiki_lon)
      p wikipedia_info[:summary]
    else
      # On retente avec le français
      p "essai fr"
      wikipedia = WikipediaService.new(destination_name, "fr")
      wikipedia_info = wikipedia.fetch_wikipedia_summary

      if wikipedia_info.present?
        if wikipedia_info[:coordinates]
          wiki_lat = wikipedia_info[:coordinates].first["lat"]
          wiki_lon = wikipedia_info[:coordinates].first["lon"]

          # Comparaison des deux coordonnées
          # p haversine_distance(google_lat, google_lon, wiki_lat, wiki_lon)
          p wikipedia_info[:summary]
        end
      end
    end
  end
end



# essai_google_wiki("New York")
# essai_google_wiki("Méribel")
essai_google_wiki("Corbel")
# essai_google_wiki("Celebes")
# essai_google_wiki("Washington D.C.")
# essai_google_wiki("Düsseldorf")
# essai_google_wiki("Gigaro")
# essai_google_wiki("La Croix-Valmer")
# essai_google_wiki("Querétaro")
# essai_google_wiki("Chiapas")
# essai_google_wiki("Arcachon")
# essai_google_wiki("Belle-Île-en-Mer")
# essai_google_wiki("La Clusaz")
# essai_google_wiki("Champagny-en-Vanoise")
# essai_google_wiki("Hyères")
# essai_google_wiki("Porquerolles")

#
# New York
# Corbel
# Sulawesi

# marin = User.where(first_name: "Mari.latn").first

# origin = { lat: result[:latitude], lng: result[:longitude] }
# destination = { lat: marin.latitude, lng: marin.longitude }
# distance_info = service.fetch_distance(origin, destination)

# distance_info[:duration_text] = distance_info[:duration_text].gsub(/\s?hour(s)?\b/, "h")

# puts distance_info


# Vérification geo searching wikipedi
