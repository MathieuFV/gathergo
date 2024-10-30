# Destroy all users
puts "Database cleanup"
puts "Destroying Users"
User.destroy_all

# Destroy all trips
puts "Destroying Trips"
Trips.destroy_all
