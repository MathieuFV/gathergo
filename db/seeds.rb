# Destroy all users
puts "Database cleanup"
puts "Destroying Users"
User.destroy_all

# Destroy all trips
puts "Destroying Trips"
Trip.destroy_all

# Users creation
users = [
  {
    name: "Marin",
    address: "Toulon"
  },
  {
    name: "Mathieu",
    address: "Paris"
  },
  {
    name: "Pierre",
    address: "Lyon"
  }
]
users.each do |user|
  puts "Creation de #{user[:name]}"
  new_user = User.new(first_name: "#{user[:name]}", address: user[:address], email: "#{user[:name].downcase}@example.com", password: "password")

  if new_user.save
    photo_path = Rails.root.join("app/assets/images/users/#{user[:name].downcase}.png") # chemin vers votre photo
    new_user.photo.attach(
      io: File.open(photo_path),
      filename: "#{user[:name].downcase}.png",
      content_type: "image/png" # Assurez-vous que le type de contenu est correct
    )
  end
end

puts "Creation de Ski 2025"
# Trips creation
trip = Trip.create(name: "Ski 2025!", start_date: '2025-01-20', end_date: '2025-03-12')
puts "Ajout des destinations à Ski 2025"
# Destinations for trip Ski 2025
Destination.create(trip: trip, name: "La Clusaz")
Destination.create(trip: trip, name: "Courchevel")
Destination.create(trip: trip, name: "Méribel")
Destination.create(trip: trip, name: "Puy-Saint-Vincent")
# Participations for trip ski 2025
puts "Ajout des participants à Ski 2025"
Participation.create(user: User.where(first_name: "Marin").first, trip: trip, role: "admin" )
Participation.create(user: User.where(first_name: "Mathieu").first, trip: trip, role: "participant" )
Participation.create(user: User.where(first_name: "Pierre").first, trip: trip, role: "participant" )


puts "Creation de Summer 25"
trip = Trip.create(name: "Summer 25", start_date: '2025-06-26', end_date: '2025-08-31')
# Destinations for trip Summer 25
puts "Ajout des destinations à Summer 25"
Destination.create(trip: trip, name: "Mykonos")
Destination.create(trip: trip, name: "Belle-Île-en-Mer")
Destination.create(trip: trip, name: "Marrakech")
Destination.create(trip: trip, name: "Madrid")
Destination.create(trip: trip, name: "Barcelone")
Destination.create(trip: trip, name: "Lisbonne")
# Participations
puts "Ajout des participants à Summer 25"
Participation.create(user: User.where(first_name: "Mathieu").first, trip: trip, role: "admin" )
Participation.create(user: User.where(first_name: "Marin").first, trip: trip, role: "participant" )
Participation.create(user: User.where(first_name: "Pierre").first, trip: trip, role: "participant" )



def fetch_correct_wikipedia_name(title)
  # On encode correctement le nom
  encoded_title = URI.encode_www_form_component(title)

  # On fait une requête avec l'action "Opensearch" pour chercher le nom correctement formaté
  search_url = URI("https://fr.wikipedia.org/w/api.php?action=opensearch&search=#{encoded_title}&limit=1&namespace=0&format=json")

  response = Net::HTTP.get(search_url)

  # On renvoie la réponse
  JSON.parse(response)
end

def fetch_wikipedia_summary(title)
  suggestions = fetch_correct_wikipedia_name(title)

  puts suggestions

  # # Vérifie si une suggestion est bien renvoyée
  if suggestions[1].any?

    puts suggestions[1].first
    # # Utilise le premier résultat comme le titre correct
    correct_title = suggestions[1].first

    # # On formate le titre pour l'API REST wikipedia
    formatted_title = correct_title.gsub(" ", "_")
    encoded_correct_title = URI.encode_www_form_component(formatted_title)
    summary_url = URI("https://fr.wikipedia.org/api/rest_v1/page/summary/#{encoded_correct_title}")

    # # Appel à l'API avec le bon titre
    summary_response = Net::HTTP.get(summary_url)
    if !summary_response.empty?
      data = JSON.parse(summary_response)
      # Si on reçoit bien de la donnée :
      if data["extract"]
        data["extract"]
      end
    end
  end
end

# Ajout de la description à chaque destination
Destination.all.each do |destination|
  description = fetch_wikipedia_summary(destination[:name])
  p description
  if description.present?
    destination.description = description
    destination.save
  end
end
