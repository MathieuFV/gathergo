require 'rails_helper'

RSpec.describe Trip, type: :model do
  describe "validations" do
    describe "name" do
      it "is invalid with an empty name" do
        trip = Trip.new(name: "", start_date: Time.new, end_date: Time.new)

        expect(trip).to be_invalid
        expect(trip.errors[:name]).to include("cannot be empty")
      end

      it "is invalid with a nil name" do
        trip = Trip.new(name: nil, start_date: Time.new, end_date: Time.new)

        expect(trip).to be_invalid
        expect(trip.errors[:name]).to include("cannot be nil")
      end
    end

    describe "dates" do
      it "is invalid with an empty start date" do
        trip = Trip.new(name: "Voyage", start_date: "", end_date: Time.new)

        expect(trip).to be_invalid
        expect(trip.errors[:start_date]).to include("cannot be empty")
      end

      it "is invalid with a nil start date" do
        trip = Trip.new(name: "Voyage", start_date: nil, end_date: Time.new)

        expect(trip).to be_invalid
        expect(trip.errors[:start_date]).to include("cannot be nil")
      end

      it "is invalid with an empty end date" do
        trip = Trip.new(name: "Voyage", end_date: "", start_date: Time.new)

        expect(trip).to be_invalid
        expect(trip.errors[:end_date]).to include("cannot be empty")
      end

      it "is invalid with a nil end date" do
        trip = Trip.new(name: "Voyage", end_date: nil, start_date: Time.new)

        expect(trip).to be_invalid
        expect(trip.errors[:end_date]).to include("cannot be nil")
      end

      it "is invalid with an end date set previsously to start date" do
        trip = Trip.new(name: "Voyage", start_date: Date.tomorrow, end_date: Date.today)

        expect(trip).to be_invalid
        expect(trip.errors[:end_date]).to include("shall be posterior to start date")
      end
    end

  end
end
