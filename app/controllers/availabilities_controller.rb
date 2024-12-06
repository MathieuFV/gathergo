class AvailabilitiesController < ApplicationController
  def index
    @trip = Trip.find(params[:trip_id])

    # Display all the availabilities of a user
    @current_user_participation = current_user.participations.find_by(trip: @trip)

    # current user availabilities
    @current_user_availabilities = @current_user_participation.availabilities.pluck(:start_date)

    # To create a new availability range
    @availability = Availability.new

    # All users who participate to the trip but the current user (to display it on top)
    # @participants = @trip.users.where.not(id: current_user.id)
    @participants = @trip.users

    # Availababilities of the participants
    @participants_availabilities = @participants.map(&:availabilities).flatten # A remplacer par flat_map ? au lieu de map puis flatten

    # Création des dates
    @dates = (@trip.start_date..@trip.end_date).to_a # .. is an inclusive range (end_date is included)
  end

  def create
    @trip = Trip.find(params[:trip_id])
    # Get user participation to add the new linked availabilities
    @current_user_participation = current_user.participations.find_by(trip: @trip)


    # New dates recuperation
    @dates = availability_params[:start_date].split(',')

    # Destroying ancient dates
    current_user.availabilities.where(participation: @current_user_participation).destroy_all

    # Dates creation
    @dates.each do |date|
      Availability.create!(
        start_date: date,
        end_date: date,
        participation: @current_user_participation
      )
    end

    redirect_to trip_availabilities_path(@trip)

    # # Get participation
    # @participation = current_user.participations.find_by(trip: @trip)
    # @availability.participation = @participation

    # if @availability.save!
    #   redirect_to trip_availabilities_path(@trip)
    # else
    #   redirect_to trip_availabilities_path(@trip)
    #   # render :index, status: :unprocessable_entity
    # end
  end

  private

  def availability_params
    params.require(:availability).permit(:start_date, :end_date)
  end
end
