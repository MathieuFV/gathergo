# Destroy all users
puts "Database cleanup"
puts "Destroying Users"
User.destroy_all

# Destroy all trips
puts "Destroying Trips"
Trips.destroy_all

# Trips creation
trip = Trip.new(name: "Ski 2025!", start_date: '2025-01-20', end_date: '2025-03-12')
Destination.new(trip: trip, name: "La Clusaz")
Destination.new(trip: trip, name: "Courchevel")
Destination.new(trip: trip, name: "Meribel")
Destination.new(trip: trip, name: "Puy-Saint-Vincent")

trip = Trip.new(name: "Summer 25", start_date: '2025-06-26', end_date: '2025-08-31')
Destination.new(trip: trip, name: "Mykonos")
Destination.new(trip: trip, name: "Belle-Île-en-Mer")
Destination.new(trip: trip, name: "Marrakech")
Destination.new(trip: trip, name: "Madrid")
Destination.new(trip: trip, name: "Barcelone")
Destination.new(trip: trip, name: "Lisbonne")
