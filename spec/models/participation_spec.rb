require 'rails_helper'

RSpec.describe Participation, type: :model do
  # it "has a valid user id" do
  # end
  let(:user) {
    User.create!(
      first_name: "François",
      address: "Paris",
      email: "francois@example.com",
      password: "password",
      phone: "3636"
    )
  }
  let(:trip) { Trip.create!(name: "Voyage", start_date: Date.today, end_date: Date.tomorrow) }

  it { should belong_to(:user) }
  it { should belong_to(:trip) }

  it { should have_many(:availabilities) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:trip_id) }
  it { should validate_presence_of(:role) }

  it { should validate_inclusion_of(:role).in_array(["admin", "participant"]) }

  it "checks that a trip can only be associated with a user once" do
    Participation.create!(user: user, trip: trip, role: "admin")
    participation2 = Participation.new(user: user, trip: trip, role: "participant")

    expect(participation2).to be_invalid
  end
end
