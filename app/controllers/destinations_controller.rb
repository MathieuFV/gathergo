class DestinationsController < ApplicationController
  require 'open-uri'

  def index
    @trip = Trip.find(params[:trip_id])
    @destinations = @trip.destinations
                        .includes(:comments, :votes)
                        .includes(trip: { participations: { user: :photo_attachment } })
  end

  def show
    @trip = Trip.find(params[:trip_id])
    @destination = Destination.find(params[:id])

    @display_top_menu = false

    # Récupération de la distance et du trajet
    service = GooglePlacesService.new(GOOGLE_PLACES_API_KEY)

    origin = { lat: @destination.latitude, lng: @destination.longitude }
    destination = { lat: current_user.latitude, lng: current_user.longitude }

    @distance_info = service.fetch_distance(origin, destination)

    # Nouvelle table pour stocker les données
  end

  def new
    @trip = Trip.find(params[:trip_id])
    @destination = Destination.new
  end

  def create
    @trip = Trip.find(params[:trip_id])
    @destination = Destination.new(destination_params)

    @destination.trip = @trip

    # Appel du service wikipedia pour récupérer des infos sur la destination
    results = WikipediaService.new(@destination.name).fetch_wikipedia_summary
    manage_wiki_results(results)

    # Sauvegarde de la nouvelle destination
    if @destination.save
      redirect_to trip_path(@trip)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def destination_params
    params.require(:destination).permit(:name)
  end

  def manage_wiki_results(results)
    # Si la recherche est fructueuse
    if results.present?
      # Ajout du résumé en tant que description de la nouvelle destination
      @destination.description = results[:summary]

      # Si une image a été trouvée
      if results[:image].present?
        # Attach image to cloudinary
        image_url = results[:image]
        @destination.photo.attach(io: URI.open(image_url), filename: "#{@destination.name}.jpg", content_type: "image/jpeg")
      end
    end
  end
end
