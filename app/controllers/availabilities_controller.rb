class AvailabilitiesController < ApplicationController
  def index
    @trip = Trip.find(params[:trip_id])

    # Display all the availabilities of a user
    @availabilities = current_user.availabilities

    # To create a new availability range
    @availability = Availability.new
  end

  def create
    @availability = Availability.new(availability_params)
    @trip = Trip.find(params[:trip_id])

    # Get participation
    @participation = current_user.participations.where(trip: @trip, user: current_user).first
    @availability.participation = @participation

    if @availability.save
      redirect_to :root
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def availability_params
    params.require(:availability).permit(:start_date, :end_date)
  end
end
