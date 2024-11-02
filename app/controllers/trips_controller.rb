class TripsController < ApplicationController
  def show
    # get all destinations of the show
    @trip = Trip.find(params[:id])
    @destinations = @trip.destinations

    @cards = @destinations
  end

  def index
    @trips = Trip.all
  end
end
