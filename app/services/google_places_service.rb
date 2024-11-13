# app/services/google_places_service.rb
class GooglePlacesService
  def initialize(api_key)
    @api_key = api_key
    @client = GooglePlaces::Client.new(api_key)
  end

  def fetch_place_details(place_name)
    begin
      # Recherche le lieu
      places = @client.spots_by_query(place_name)

      return nil if places.empty?

      # Prend le premier résultat
      place = places.first

      # Récupère les détails complets
      details = @client.spot(place.place_id)

      # Utilisation des 10 premières photos pour les ajouter aux destinations
      photos = details.photos
      photos = photos.map do |photo|
        if photo.photo_reference
          build_photo_url(photo.photo_reference)
        end
      end

      # Construit l'URL de la photo
      # photo_reference = details.photos&.first&.photo_reference
      # photo_url = photo_reference ? build_photo_url(photo_reference) : nil

      {
        name: details.name,
        description: details.formatted_address + "\n" + (details.reviews&.first&.text || ""),
        photos_url: photos,
        latitude: details.lat,
        longitude: details.lng
      }
    rescue => e
      Rails.logger.error("Error fetching place details for #{place_name}: #{e.message}")
      nil
    end
  end

  # Méthode pour obtenir la distance et le temps de trajet
  def fetch_distance(origin, destination)
    url = URI("https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{origin[:lat]},#{origin[:lng]}&destinations=#{destination[:lat]},#{destination[:lng]}&key=#{@api_key}")

    response = Net::HTTP.get(url)
    data = JSON.parse(response)

    p data

    if data["status"] == "OK"
      element = data["rows"].first["elements"].first
      {
        distance_text: element["distance"]["text"],
        distance_value: element["distance"]["value"], # en mètres
        duration_text: element["duration"]["text"],
        duration_value: element["duration"]["value"] # en secondes
      }
    else
      Rails.logger.error("Error fetching distance: #{data['error_message']}")
      nil
    end
  rescue => e
    Rails.logger.error("Error in fetch_distance: #{e.message}")
    nil
  end

  private

  def build_photo_url(photo_reference)
    "https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photo_reference=#{photo_reference}&key=#{@api_key}"
  end
end
