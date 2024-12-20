class TripsController < ApplicationController
  def show
    # get all destinations of the trip
    @trip = Trip.find(params[:id])
    @destinations = @trip.destinations.includes(:comments, :votes)
  end

  def index
    # Hide margins for top and nav bars
    @display_bottom_menu == false
    @display_top_menu = false

    @trips = current_user.trips

    # Vérifie si les paramètres pour le formulaire de suggestion sont présents
    if params[:travel_type].present? && params[:budget].present?
      @suggestions = fetch_suggestions(
        travel_type: params[:travel_type],
        budget: params[:budget],
        duration: params[:duration],
        season: params[:season],
        region: params[:region]
      )
    end
  end

  def join
    @trip = Trip.find(params[:id])

    # Si le user appartient déjà au voyage
    if current_user.trips.include?(@trip)
      redirect_to trip_path(@trip)
    end
  end

  def add_participant
    @trip = Trip.find(params[:id])

    # Create new participation
    @participation = Participation.new(user: current_user, trip: @trip, role: "participant")
    if @participation.save
      redirect_to trip_path(@trip)
    else
      render :join, status: :unprocessable_entity
    end
  end
  private

  # Méthode privée pour construire le prompt et appeler l'API OpenAI
  def fetch_suggestions(travel_type:, budget:, duration: nil, season: nil, region: nil)
    prompt = <<~PROMPT
    Je suis un assistant voyage. L'utilisateur souhaite des suggestions de destinations adaptées à ses préférences.

    Voici les informations fournies :
    - Type de voyage : #{travel_type}
    - Budget : #{budget}
    - Durée : #{duration || "non spécifiée"}
    - Période : #{season || "non spécifiée"}
    - Région : #{region || "non spécifiée"}

    Propose 3 destinations correspondant à ces critères. Pour chaque destination, donne :
    1. Le nom de la destination (en gras).
    2. Une description en une ou deux phrases.
    3. Une suggestion d'activité ou recommandation.

    Format attendu (HTML) :

    <ul>
      <li><b>[Nom de la destination]</b> : Description. Suggestion d'activité/recommandation.</li>
      ...
    </ul>
  PROMPT


    # Appel à l'API OpenAI
    response = OpenAI::Client.new.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: prompt }],
        temperature: 0.7
      }
    )

    # Extraction et renvoi des suggestions
    response.dig("choices", 0, "message", "content")
  end
end
