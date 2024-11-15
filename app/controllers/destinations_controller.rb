class DestinationsController < ApplicationController
  require 'open-uri'

  def index
    @trip = Trip.find(params[:trip_id])
    @destinations = @trip.destinations
                        .order(votes_count: :desc)
                        .includes(:comments, :votes)
                        .includes(trip: { participations: { user: :photo_attachment } })
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

    # Appel du service google place pour récupérer des photos sur la destination
    places_service = GooglePlacesService.new(ENV['GOOGLE_GEOCODING_API_KEY'])
    google_place_info = places_service.fetch_place_details(@destination.name)
    manage_googe_place_results(google_place_info)

    # Appel de l'api wikipedia
    if google_place_info[:name].present?
      # Utilisation du nom normalisé par google place
      wikipedia_info = WikipediaService.new(google_place_info[:name]).fetch_wikipedia_summary
    else
      # Utilisation du nom brut sinon
      wikipedia_info = WikipediaService.new(@destination.name).fetch_wikipedia_summary
    end

    # Appel du service wikipedia pour récupérer des infos sur la destination
    manage_wiki_results(wikipedia_info)

    # Sauvegarde de la nouvelle destination
    if @destination.save
      redirect_to trip_path(@trip)
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

  def manage_wiki_results(wikipedia_info)
    # Si la recherche est fructueuse
    if wikipedia_info.present?
      # Ajout du résumé en tant que description de la nouvelle destination
      @destination.description = wikipedia_info[:summary]
    else
      # Si aucune information wikipédia trouvée
      @destination.description = "No information found on Wikipedia about #{@destination.name}"
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
