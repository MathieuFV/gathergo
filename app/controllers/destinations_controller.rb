class DestinationsController < ApplicationController
  def index
    @trip = Trip.find(params[:trip_id])

    @destinations = @trip.destinations
  end

  def show
    @trip = Trip.find(params[:trip_id])
    @destination = Destination.find(params[:id])
  end
end
