class TripsController < ApplicationController
  def show
    # get all destinations of the trip
    @trip = Trip.find(params[:id])
    @destinations = @trip.destinations.includes(:comments, :votes)
  end

  def index
    @trips = current_user.trips
    @display_bottom_menu = false
@display_top_menu = false
  end

  def join
    @trip = Trip.find(params[:id])

    # Si le user appartient déjà au voyage
    if current_user.trips.include?(@trip)
      redirect_to trip_path(@trip)
    end
  end

  def add_participant
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
