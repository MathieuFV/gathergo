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
    photo_path = Rails.root.join("app/assets/images/users/#{user[:name].downcase}.png")
    new_user.photo.attach(
      io: File.open(photo_path),
      filename: "#{user[:name].downcase}.png",
      content_type: "image/png"
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
# Destination.create(trip: trip, name: "meribel")
# Destination.create(trip: trip, name: "Puy-Saint-Vincent")
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
# Destination.create(trip: trip, name: "Marrakech")
# Destination.create(trip: trip, name: "Madrid")
# Destination.create(trip: trip, name: "Barcelone")
# Destination.create(trip: trip, name: "Lisbonne")
# Participations
puts "Ajout des participants à Summer 25"
Participation.create(user: User.where(first_name: "Mathieu").first, trip: trip, role: "admin" )
Participation.create(user: User.where(first_name: "Marin").first, trip: trip, role: "participant" )
Participation.create(user: User.where(first_name: "Pierre").first, trip: trip, role: "participant" )

# Initialisation du service Google Places
places_service = GooglePlacesService.new(GOOGLE_PLACES_API_KEY)

# Ajout de la description à chaque destination
puts "Ajout des descriptions et photos aux destinations"
Destination.all.each do |destination|

  # Appel du service Google Place
  puts "Récupération des informations Google Place pour #{destination.name}"
  result = places_service.fetch_place_details(destination.name)

  # Si l'API a bien renvoyé un résultat sur la destination
  if result.present?
    # Appel du service WikipediaService (créé dans "app/services" pour pouvoir être réutilisé ailleurs)
    puts "Recherche d'informations wikipedia sur #{destination.name}"
    wikipedia_infos = WikipediaService.new(result[:name]).fetch_wikipedia_summary
    if wikipedia_infos.present?
      destination.description = wikipedia_infos[:summary]
    end

    puts "Informations Google Place trouvées pour #{destination.name}"

    # Si au moins une photo est rattachée à la destination
    if result[:photos_url].present?
      begin
                          # Limite à 5 photos
        result[:photos_url].take(5).each_with_index do |photo_url, index|
          puts "Ajout de la photo #{index} pour #{destination.name}"
          # Ajout de la photo à la destination
          destination.photos.attach(
            io: URI.open(photo_url),
            filename: "#{destination.name}#{index}.jpg",
            content_type: "image/jpeg"
          )
          puts "Photo #{index} ajoutée avec succès pour #{destination.name}"
        end
      rescue => e
        puts "Erreur lors de l'ajout de la photo pour #{destination.name}: #{e.message}"
      end
    else
      puts "Pas de photo disponible pour #{destination.name}"
    end

    # Ajoute les coordonnées si ton modèle les supporte
    # if destination.respond_to?(:latitude=) && destination.respond_to?(:longitude=)
    #   destination.latitude = result[:latitude]
    #   destination.longitude = result[:longitude]
    #   puts "Coordonnées ajoutées pour #{destination.name}"
    # end

    if destination.save
      puts "#{destination.name} mis à jour avec succès"
    else
      puts "Erreur lors de la sauvegarde de #{destination.name}: #{destination.errors.full_messages.join(', ')}"
    end
  else
    puts "Aucune information google trouvée pour #{destination.name}"
    # Essai de la recherche wikipedia avec le nom seulement
    puts "Recherche d'informations wikipedia sur #{destination.name}"
    wikipedia_infos = WikipediaService.new(destination.name).fetch_wikipedia_summary
    if wikipedia_infos.present?
      destination.description = wikipedia_infos[:summary]
    end
  end

  # Pause pour respecter les limites de l'API
  sleep 1.5
end

# Après ta boucle Destination.all.each mais avant le "puts 'Seed terminé avec succès!'"

puts "Ajout des commentaires et des votes aux destinations"
Destination.all.each do |destination|
  puts "Ajout des interactions pour #{destination.name}"

  # Création de quelques commentaires aléatoires
  User.all.sample(2).each do |user|
    comment = Comment.create!(
      user: user,
      commentable: destination,
      content: [
        "#{destination.name} est un super endroit !",
        "J'ai adoré #{destination.name}, je recommande !",
        "Je suis déjà allé à #{destination.name}, c'est magnifique.",
        "#{destination.name} est parfait pour ce voyage !",
        "Excellente idée d'aller à #{destination.name} !"
      ].sample,
      created_at: rand(1..10).days.ago
    )
    puts "Commentaire ajouté par #{user.first_name} pour #{destination.name}"
  end

  # Création de votes aléatoires (certains utilisateurs votent, d'autres non)
  User.all.each do |user|
    if rand > 0.3 # 70% de chance de voter
      Vote.create!(
        user: user,
        votable: destination
      )
      puts "Vote ajouté par #{user.first_name} pour #{destination.name}"
    end
  end
end

puts "\nRécapitulatif des interactions :"
puts "#{Comment.count} commentaires créés"
puts "#{Vote.count} votes ajoutés"

puts "Seed terminé avec succès!"
