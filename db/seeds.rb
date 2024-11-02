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
Destination.create(trip: trip, name: "meribel")
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

def fetch_wikipedia_summary(title)
  if title.present?
    correct_title = title

    # Construction de l'URL pour l'Action API de Wikipédia
    api_url = URI("https://fr.wikipedia.org/w/api.php")

    # Définition des paramètres pour obtenir un extrait complet et les coordonnées
    params = {
      action: 'query',
      format: 'json',
      prop: 'extracts|pageimages',
      exintro: 1,
      explaintext: 1,
      redirects: 1,           # Redirige vers une orthographe plausible
      titles: correct_title,
      exsectionformat: 'plain', # Format des sections en texte brut
      pithumbsize: 500
    }

    # Construction de la requête avec les paramètres
    api_url.query = URI.encode_www_form(params)

    # Appel à l'API avec le bon titre
    summary_response = Net::HTTP.get(api_url)

    unless summary_response.empty?
      data = JSON.parse(summary_response)

      result = data["query"]["pages"].values.first
      title = result["title"]
      image = result["thumbnail"]["source"]

      # Navigue dans la structure JSON pour obtenir l'extrait
      pages = data["query"]["pages"]
      page = pages.values.first

      if page && result && image
        p "summary and image"
        fetched_data = { summary: result["extract"], image: image }
      elsif page && result
        p "only summary"
        fetched_data = { summary: result["extract"] }
      else
        puts "Aucun extrait trouvé pour le titre : #{correct_title}"
        return nil
      end
    else
      puts "Réponse vide de l'API pour le titre : #{correct_title}"
      return nil
    end
  else
    puts "Titre invalide ou vide : #{title}"
    return nil
  end
end

# Ajout de la description à chaque destination
Destination.all.each do |destination|
  result = fetch_wikipedia_summary(destination[:name])
  if result.present?
    destination.description = result[:summary]
    if result[:image].present?
      # Attach image to cloudinary
      image_url = result[:image]
      destination.photo.attach(io: URI.open(image_url), filename: "#{destination.name}.jpg", content_type: "image/jpeg")
    end

    destination.save
  end
end
