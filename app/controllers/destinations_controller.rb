class DestinationsController < ApplicationController
  require 'open-uri'

  def index
    @trip = Trip.find(params[:trip_id])
    @destinations = @trip.destinations.includes(:votes, :owner)
    @destinations = @destinations.map do |destination|
      {
        id: destination.id,
        trip_id: @trip.id,
        title: destination.name,
        image_url: destination.photos.first ?
                  helpers.url_for(destination.photos.first) :
                  helpers.asset_path('default_destination.jpg'),
        link_path: trip_destination_path(@trip, destination),
        comments_count: destination.comments_count || 0,
        likes_count: destination.votes.count || 0,
        voted_by_current_user: destination.votes.exists?(user: current_user),
        user: {
          avatar_url: destination.owner.photo.attached? ?
                     helpers.url_for(destination.owner.photo) :
                     helpers.asset_path('default_avatar.png'),
          name: destination.owner.first_name
        },
        created_at: destination.created_at
      }
    end
  end

  def show
    @trip = Trip.find(params[:trip_id])
    @destination = Destination.find(params[:id])

    @display_top_menu = false

    # Récupération de la distance et du trajet
    service = GooglePlacesService.new(ENV['GOOGLE_GEOCODING_API_KEY'])

    origin = { lat: @destination.latitude, lng: @destination.longitude }
    destination = { lat: current_user.latitude, lng: current_user.longitude }

    @distance_info = service.fetch_distance(origin, destination)

    if @distance_info[:distance_text] == nil
      @distance_info[:distance_text] = haversine_distance(origin[:lat], origin[:lng], destination[:lat], destination[:lng]).to_i
    end

    # Affichage des commentaires
    @comments = @destination.comments
  end

  def new
    @trip = Trip.find(params[:trip_id])
    @destination = Destination.new
  end

  def create
    @trip = Trip.find(params[:trip_id])
    @destination = Destination.new(destination_params)

    @destination.trip = @trip

    @destination.owner = current_user

    # Appel du service google place pour récupérer des photos sur la destination
    places_service = GooglePlacesService.new(ENV['GOOGLE_GEOCODING_API_KEY'])
    google_place_info = places_service.fetch_place_details(@destination.name)
    manage_googe_place_results(google_place_info)

    # Appel de l'api wikipedia
    if google_place_info[:name].present?
      # Utilisation du nom normalisé par google place
      # wikipedia_info = WikipediaService.new(google_place_info[:name], "en").fetch_wikipedia_summary
      wikipedia_info = WikipediaService.new(@destination.name, "en").fetch_wikipedia_summary
    else
      # Utilisation du nom brut sinon
      wikipedia_info = WikipediaService.new(@destination.name, "en").fetch_wikipedia_summary
    end

    # Appel du service wikipedia pour récupérer des infos sur la destination
    manage_wiki_results(wikipedia_info, google_place_info)

    # Sauvegarde de la nouvelle destination
    if @destination.save
      redirect_to trip_destination_path(@trip, @destination)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @destination = Destination.find(params[:id])
    @destination.destroy

    @trip = Trip.find(params[:trip_id])
    redirect_to trip_path(@trip)
  end

  private

  def destination_params
    params.require(:destination).permit(:name)
  end

  # WIKIPEDIA (A placer dans le service wikipedia pour refacto)
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

  # WIKIPEDIA (A placer dans le service wikipedia pour refacto)
  def wikipedia_page_relevant?(wikipedia_info, google_info)
    # Coordinates recuperation (from wikipedia result and google)
    if wikipedia_info[:coordinates]
      wiki_latitude = wikipedia_info[:coordinates].first["lat"]
      wiki_longitude = wikipedia_info[:coordinates].first["lon"]
      google_latitude = google_info[:latitude]
      google_longitude = google_info[:longitude]

      return true
    else
      return false
    end

    distance = haversine_distance(google_latitude, google_longitude, wiki_latitude, wiki_longitude)

    # Distance calculation between the two destinations
    distance < 3 ? true : false
  end

  def manage_wiki_results(wikipedia_info, google_info)
    # Si la recherche est fructueuse
    if wikipedia_info.present?
      # Coordinates comparaison (to improve wikipedia accurency)
      if wikipedia_page_relevant?(wikipedia_info, google_info)
        puts "Relevant Wikipedia page found for #{google_info[:name]}"
        @destination.description = wikipedia_info[:summary]
      elsif google_info[:website]
        puts "Non relevant"
        @destination.description = "No information directly found on Wikipedia about #{@destination.name}. More on #{google_info[:website]}"
      end
    else
      # Si aucune information wikipédia trouvée@de
      @destination.description = "No information found about #{@destination.name}"
    end
  end

  def manage_googe_place_results(google_place_info)
    if google_place_info[:latitude] && google_place_info[:longitude]
      @destination.latitude = google_place_info[:latitude]
      @destination.longitude = google_place_info[:longitude]
    end

    if google_place_info[:photos_url].present?
      begin
                            # Limite à 5 photos
        google_place_info[:photos_url].take(5).each_with_index do |photo_url, index|
          puts "Ajout de la photo #{index} pour #{@destination.name}"
          # Ajout de la photo à la destination
          @destination.photos.attach(
            io: URI.open(photo_url),
            filename: "#{@destination.name}#{index}.jpg",
            content_type: "image/jpeg"
          )
          puts "Photo #{index} ajoutée avec succès pour #{@destination.name}"
        end
      rescue => e
        puts "Erreur lors de l'ajout de la photo pour #{@destination.name}: #{e.message}"
      end
    else
      puts "Pas de photo disponible pour #{@destination.name}"
    end
  end
end
