class DestinationsController < ApplicationController
  def index
    @trip = Trip.find(params[:trip_id])

    @destinations = @trip.destinations
  end
end
