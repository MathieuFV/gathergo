require 'rails_helper'

RSpec.describe Destination, type: :model do
  # Association
  it { should belong_to(:trip) }

  it { should validate_presence_of(:trip_id) }
  it { should validate_presence_of(:name) }
end
