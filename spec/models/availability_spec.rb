require 'rails_helper'

RSpec.describe Availability, type: :model do
  let(:user) {
    User.create!(
      first_name: "Michel",
      address: "Rue lamalgue, Toulon",
      email: "michel@example.com",
      password: "password"
    )
  }
  let(:trip) { Trip.create!(name: "trip", start_date: Date.today, end_date: Date.tomorrow) }
  let(:participation) { Participation.create!(user: user, trip: trip, role: "admin") }

  it { should belong_to(:participation) }

  it { should validate_presence_of(:participation_id) }
  it { should validate_presence_of(:start_date) }
  it { should validate_presence_of(:end_date) }

  it "is invalid with an end date set previsously to start date" do
    availability = Availability.new(participation: participation, start_date: Date.tomorrow, end_date: Date.today)

    expect(availability).to be_invalid
  end

  it "is valid with an end date equal to start date" do
    availability = Availability.new(participation: participation, start_date: Date.today, end_date: Date.today)

    expect(availability).to be_valid
  end

  it "has unique couples of start_date & end_date, associated with a participation" do
    participation = Participation.create!(user: user, trip: trip, role: "admin")

    availability1 = Availability.create!(participation: participation, start_date: Date.yesterday, end_date: Date.tomorrow )
    availability2 = Availability.new(participation: participation, start_date: Date.yesterday, end_date: Date.tomorrow )

    expect(availability2).to be_invalid
  end
end
