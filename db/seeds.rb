def clean_database
  puts "Database cleanup"
  puts "Destroying Users and Trips"
  User.destroy_all
  Trip.destroy_all
end

def create_users
  puts "Creating users"
  users = [
    { name: "Marin", address: "Toulon" },
    { name: "Mathieu", address: "Paris" },
    { name: "Pierre", address: "Lyon" }
  ]

  created_users = {}
  users.each do |user|
    puts "Creation de #{user[:name]}"
    new_user = User.new(
      first_name: user[:name],
      address: user[:address],
      email: "#{user[:name].downcase}@example.com",
      password: "password"
    )

    if new_user.save
      created_users[user[:name]] = new_user
      attach_user_photo(new_user)
    end
  end
  created_users
end

def attach_user_photo(user)
  photo_path = Rails.root.join("app/assets/images/users/#{user.first_name.downcase}.png")
  user.photo.attach(
    io: File.open(photo_path),
    filename: "#{user.first_name.downcase}.png",
    content_type: "image/png"
  )
end

def create_trip(name:, dates:, admin:, users:)
  puts "Creating #{name}"
  trip = Trip.create!(name: name, start_date: dates[:start], end_date: dates[:end])
  
  users.values.each do |user|
    Participation.create!(
      user: user,
      trip: trip,
      role: user == admin ? "admin" : "participant"
    )
  end
  trip
end

def create_destination(trip:, name:, owner:)
  Destination.create!(
    trip: trip,
    name: name,
    owner_id: owner.id
  )
end

def enrich_destination(destination)
  puts "Enriching #{destination.name}"
  places_service = GooglePlacesService.new(ENV['GOOGLE_GEOCODING_API_KEY'])
  result = places_service.fetch_place_details(destination.name)

  if result.present?
    add_wikipedia_description(destination, result[:name])
    add_google_photos(destination, result[:photos_url])
    destination.save
  else
    add_wikipedia_description(destination, destination.name)
  end

  sleep 1.5 # Respect API limits
end

def add_wikipedia_description(destination, search_term)
  wikipedia_info = WikipediaService.new(search_term).fetch_wikipedia_summary
  if wikipedia_info.present?
    destination.description = wikipedia_info[:summary]
  end
end

def add_google_photos(destination, photos_urls)
  return unless photos_urls.present?

  photos_urls.take(5).each_with_index do |photo_url, index|
    begin
      destination.photos.attach(
        io: URI.open(photo_url),
        filename: "#{destination.name}#{index}.jpg",
        content_type: "image/jpeg"
      )
    rescue => e
      puts "Error adding photo #{index} for #{destination.name}: #{e.message}"
    end
  end
end

def add_interactions(destination)
  add_comments(destination)
  add_votes(destination)
end

def add_comments(destination)
  User.all.sample(2).each do |user|
    Comment.create!(
      user: user,
      commentable: destination,
      content: random_comment(destination.name),
      created_at: rand(1..10).days.ago
    )
  end
end

def add_votes(destination)
  User.all.each do |user|
    if rand > 0.3 # 70% chance to vote
      Vote.create!(user: user, votable: destination)
    end
  end
end

def random_comment(destination_name)
  [
    "#{destination_name} est un super endroit !",
    "J'ai adoré #{destination_name}, je recommande !",
    "Je suis déjà allé à #{destination_name}, c'est magnifique.",
    "#{destination_name} est parfait pour ce voyage !",
    "Excellente idée d'aller à #{destination_name} !"
  ].sample
end

# Exécution du seed
clean_database
users = create_users

# Création des trips
trip_ski = create_trip(
  name: "Ski 2025!",
  dates: { start: '2025-01-20', end: '2025-03-12' },
  admin: users["Marin"],
  users: users
)

trip_summer = create_trip(
  name: "Summer 25",
  dates: { start: '2025-06-26', end: '2025-08-31' },
  admin: users["Pierre"],
  users: users
)

# Création des destinations
destinations = [
  { trip: trip_ski, name: "La Clusaz", owner: users["Marin"] },
  { trip: trip_ski, name: "Courchevel", owner: users["Mathieu"] },
  { trip: trip_summer, name: "Mykonos", owner: users["Pierre"] },
  { trip: trip_summer, name: "Belle-Île-en-Mer", owner: users["Mathieu"] }
].map { |dest| create_destination(**dest) }

# Enrichissement des destinations
destinations.each do |destination|
  enrich_destination(destination)
  add_interactions(destination)
end

puts "\nRécapitulatif des interactions :"
puts "#{Comment.count} commentaires créés"
puts "#{Vote.count} votes ajoutés"
puts "Seed terminé avec succès!"
