class TripsController < ApplicationController
  def show
    # get all destinations of the trip
    @trip = Trip.find(params[:id])
    @destinations = @trip.destinations.includes(:comments, :votes)

    # On vérifie si le trip fait partie des trips du current user
    # Si oui, on affiche le trip

    # Si non, on redirige vers la page d'ajout du trip
  end

  def index
    @trips = current_user.trips
  end

  def join
    @trip = Trip.find(params[:trip_id])

    # Si le user appartient déjà au voyage
    unless current_user.trips.include?(@trip)
      redirect_to trip_path(@trip)
    else

    end
  end

  def add_participant
    raise
    @trip = Trip.find(params[:trip_id])

    # Create new participation
    @participation = Participation.new(user: current_user, trip: @trip, role: "participant")
    if @participation.save
      redirect_to trip_path(@trip)
    else
      render :join, status: :unprocessable_entity
    end
  end
end
