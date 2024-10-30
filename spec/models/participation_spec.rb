require 'rails_helper'

RSpec.describe Participation, type: :model do
  # it "has a valid user id" do
  # end
  it { should belong_to(:user) }
  it { should belong_to(:trip) }

  it { should have_many(:availabilities) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:trip_id) }
  it { should validate_presence_of(:role) }

  it { should validate_inclusion_of(:role).in_array(["admin", "paticipant"]) }

  it "checks that a trip can only be associated with a user once" do
    user = User.create!(
      first_name: "François",
      address: "Paris",
      email: "francois@example.com",
      password: "password",
      phone: "3636")

    trip = Trip.create!(name: "Voyage", start_date: Date.today, end_date: Date.tomorrow)

    participation = Participation.create!(user: user, trip: trip, role: "admin")
    participation2 = Participation.new(user: user, trip: trip, role: "participant")

    expect(participation2).to be_invalid
  end
end
