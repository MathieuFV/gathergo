require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with a first name, address and email" do
    user = User.new(first_name: "Michel", address: "Rue lamalgue, Toulon",
                    email: "michel@example.com", password: "password")
    expect(user).to be_valid
  end

  it "is invalid with a nil first name" do
    user = User.new(first_name: nil, address: "Rue lamalgue, Toulon",
                    email: "michel@example.com", password: "password")
    expect(user).to be_invalid
  end

  it "is invalid with an empty first name" do
    user = User.new(first_name: "", address: "Rue lamalgue, Toulon",
                    email: "michel@example.com", password: "password")
    expect(user).to be_invalid
  end

  # Je veux vérifier que :

  # Un user peut avoir plusieurs participations à différents voyages
  it "has many participations" do
    user = User.create!(first_name: "Michel", address: "Rue lamalgue, Toulon",
                    email: "michel@example.com", password: "password")

    trip = Trip.create!(name: "Voyage")
    trip2 = Trip.create!(name: "Voyage2")

    p1 = Participation.create!(user: user, trip: trip, role: "member")
    p2 = Participation.create!(user: user, trip: trip2, role: "admin")

    expect(user.participations).to include(p1, p2)
  end

  # Un user ne peut avoir qu'une participation par voyage => Faux, validations à mettre côté participation
  # it "has only one participation per trip" do
  #   user = User.create!(first_name: "Michel", address: "Rue lamalgue, Toulon",
  #                       email: "michel@example.com", password: "password")

  #   trip = Trip.create!(name: "Voyage")
  #   p1 = Participation.create!(user: user, trip: trip, role: "member")

  #   p2 = Participation.new(user: user, trip: trip, role: "admin")

  #   expect(per).to include(p1, p2)
  # end

  # Un user peut avoir plusieurs voyages (through participations)
  it "has many trips" do
    user = User.create!(first_name: "Michel", address: "Rue lamalgue, Toulon",
                        email: "michel@example.com", password: "password")

    trip = Trip.create!(name: "Voyage")
    trip2 = Trip.create!(name: "Voyage2")

    Participation.create!(user: user, trip: trip, role: "member")
    Participation.create!(user: user, trip: trip2, role: "admin")

    expect(user.trips).to include(trip, trip2)
  end

  # Si je supprime un user, je supprime ses participations
  it "destroys linked participations if deleted" do
    user = User.create!(first_name: "Michel", address: "Rue lamalgue, Toulon",
                        email: "michel@example.com", password: "password")

    trip = Trip.create!(name: "Voyage")
    participation = Participation.create!(user: user, trip: trip, role: "member")

    user.destroy
    expect(Participation.all).not_to include(participation)
  end

  # Si je supprime un user, je ne supprime pas les voyages
  it "does not destroy trips if deleted" do
    user = User.create!(first_name: "Michel", address: "Rue lamalgue, Toulon",
                        email: "michel@example.com", password: "password")

    trip = Trip.create!(name: "Voyage")
    Participation.create!(user: user, trip: trip, role: "member")

    user.destroy
    expect(Trip.all).to include(trip)
  end
end
