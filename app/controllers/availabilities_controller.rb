class AvailabilitiesController < ApplicationController
  def index
    @trip = Trip.find(params[:trip_id])

    # Display all the availabilities of a user
    @current_user_participation = current_user.participations.where(trip: @trip, user: current_user).first
    # current user availabilities
    @availabilities = @current_user_participation.availabilities

    # To create a new availability range
    @availability = Availability.new

    # All users who participate to the trip but the current user (to display it on top)
    # @participants = @trip.users.where.not(id: current_user.id)
    @participants = @trip.users

    # Availababilities of the participants
    @participants_availabilities = @participants.map(&:availabilities).flatten

    # Création des dates
    @dates = (@trip.start_date...@trip.end_date).to_a
  end

  def create
    @availability = Availability.new(availability_params)
    @trip = Trip.find(params[:trip_id])

    # Get participation
    @participation = current_user.participations.find_by(trip: @trip)
    @availability.participation = @participation

    if @availability.save
      redirect_to trip_availabilities_path(@trip)
    else
      @availabilities = @participation.availabilities
      render :index, status: :unprocessable_entity
    end
  end

  private

  def availability_params
    params.require(:availability).permit(:start_date, :end_date)
  end
end
