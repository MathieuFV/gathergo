require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) {
    User.create!(
      first_name: "Michel",
      address: "Rue lamalgue, Toulon",
      email: "michel@example.com",
      password: "password"
    )
  }
  let(:trip) { Trip.create!(name: "trip", start_date: Date.today, end_date: Date.tomorrow) }
  let(:trip2) { Trip.create!(name: "trip2", start_date: Date.today, end_date: Date.tomorrow) }

  it "is valid with a first name, address and email" do
    expect(user).to be_valid
  end

  it "is invalid with a nil first name" do
    user.first_name = nil

    expect(user).to be_invalid
  end

  it "is invalid with an empty first name" do
    user.first_name = ""

    expect(user).to be_invalid
  end

  # Je veux vérifier que :

  # Un user peut avoir plusieurs participations à différents voyages
  it "has many participations" do
    p1 = Participation.create!(user: user, trip: trip, role: "participant")
    p2 = Participation.create!(user: user, trip: trip2, role: "admin")

    expect(user.participations).to include(p1, p2)
  end

  # Un user peut avoir plusieurs voyages (through participations)
  it "has many trips" do
    Participation.create!(user: user, trip: trip, role: "participant")
    Participation.create!(user: user, trip: trip2, role: "admin")

    expect(user.trips).to include(trip, trip2)
  end

  # Si je supprime un user, je supprime ses participations
  it "destroys linked participations if deleted" do
    participation = Participation.create!(user: user, trip: trip, role: "participant")

    user.destroy
    expect(Participation.all).not_to include(participation)
  end

  # Si je supprime un user, je ne supprime pas les voyages
  it "does not destroy trips if deleted" do
    Participation.create!(user: user, trip: trip, role: "participant")

    user.destroy
    expect(Trip.all).to include(trip)
  end
end
