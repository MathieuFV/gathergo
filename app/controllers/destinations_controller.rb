class DestinationsController < ApplicationController
  def index
    @trip = Trip.find(params[:trip_id])

    @destinations = @trip.destinations
  end

  def show
    @trip = Trip.find(params[:trip_id])
    @destination = Destination.find(params[:id])
  end

  def new
    @trip = Trip.find(params[:trip_id])
    @destination = Destination.new
  end

  def create
    @trip = Trip.find(params[:trip_id])
    @destination = Destination.new(destination_params)

    @destination.trip = @trip

    if @destination.save
      redirect_to trip_path(@trip)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def destination_params
    params.require(:destination).permit(:name)
  end
end
