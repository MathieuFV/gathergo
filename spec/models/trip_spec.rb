require 'rails_helper'

RSpec.describe Trip, type: :model do
  # Création d'un objet réutilisable
  let(:trip) { Trip.create!(name: "Trip", start_date: Date.today, end_date: Date.tomorrow) }
  let(:user) {
    User.create!(
      first_name: "Michel",
      address: "Bordeaux",
      email: "michel@example.com",
      password: "password",
      phone: "0630212782"
    )
  }

  describe "validations" do
    describe "name" do
      it "is invalid with an empty name" do
        trip = Trip.new(name: "", start_date: Date.today, end_date: Date.tomorrow)

        expect(trip).to be_invalid
      end

      it "is invalid with a nil name" do
        trip = Trip.new(name: nil, start_date: Date.today, end_date: Date.tomorrow)

        expect(trip).to be_invalid
      end
    end

    describe "dates" do
      it "is invalid with an empty start date" do
        trip = Trip.new(name: "Voyage", start_date: "", end_date: Date.today)

        expect(trip).to be_invalid
      end

      it "is invalid with a nil start date" do
        trip = Trip.new(name: "Voyage", start_date: nil, end_date: Date.today)

        expect(trip).to be_invalid
      end

      it "is invalid with an empty end date" do
        trip = Trip.new(name: "Voyage", end_date: "", start_date: Date.today)

        expect(trip).to be_invalid
      end

      it "is invalid with a nil end date" do
        trip = Trip.new(name: "Voyage", end_date: nil, start_date: Date.today)

        expect(trip).to be_invalid
      end

      it "is invalid with an end date set previsously to start date" do
        trip = Trip.new(name: "Voyage", start_date: Date.tomorrow, end_date: Date.today)

        expect(trip).to be_invalid
      end
    end
  end

  describe "relations" do
    it "has many destinations" do
      destination1 = Destination.create!(trip: trip, name: "first destination")
      destination2 = Destination.create!(trip: trip, name: "second destination")

      expect(trip.destinations).to include(destination1, destination2)
    end

    it "has many participations" do
      user2 = User.create!(first_name: "François", address: "Paris", email: "francois@example.com", password: "password", phone: "3636")

      participation1 = Participation.create!(user: user, trip: trip, role: "admin")
      participation2 = Participation.create!(user: user2, trip: trip, role: "participant")

      expect(trip.participations).to include(participation1, participation2)
    end

    it "has many users through participations" do
      user2 = User.create!(first_name: "François", address: "Paris", email: "francois@example.com", password: "password", phone: "3636")

      participation1 = Participation.create!(user: user, trip: trip, role: "admin")
      participation2 = Participation.create!(user: user2, trip: trip, role: "participant")

      expect(trip.users).to include(user, user2)
    end

    it "should destroy associated participations if deleted" do
      p1 = Participation.create!(user: user, trip: trip, role: "admin")

      trip.destroy

      expect(Participation.all).to_not include(p1)
    end

    it "should destroy associated destinations if deleted" do
      d1 = Destination.create!(trip: trip, name: "Destination")

      trip.destroy

      expect(Destination.all).to_not include(d1)
    end
  end
end
