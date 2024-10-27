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
end
