class TripsController < ApplicationController
  def show
    # get all destinations of the trip
    @trip = Trip.find(params[:id])
    @destinations = @trip.destinations.includes(:comments, :votes)
  end

  def index
    # Filtre des voyages en fonction du user
    @trips = current_user.trips

  end
end
