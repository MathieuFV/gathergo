# require 'net/http'
# require 'json'
# require 'uri'

# def fetch_wikipedia_summary(title)
#   if title.present?
#     correct_title = title

#     # Construction de l'URL pour l'Action API de Wikipédia
#     api_url = URI("https://fr.wikipedia.org/w/api.php")

#     # Définition des paramètres pour obtenir un extrait complet et les coordonnées
#     params = {
#       action: 'query',
#       format: 'json',
#       prop: 'extracts|pageimages',
#       exintro: 1,
#       explaintext: 1,
#       redirects: 1,           # Redirige vers une orthographe plausible
#       titles: correct_title,
#       exsectionformat: 'plain', # Format des sections en texte brut
#       pithumbsize: 500
#     }

#     # Construction de la requête avec les paramètres
#     api_url.query = URI.encode_www_form(params)

#     # Appel à l'API avec le bon titre
#     summary_response = Net::HTTP.get(api_url)

#     unless summary_response.empty?
#       data = JSON.parse(summary_response)

#       result = data["query"]["pages"].values.first
#       title = result["title"]
#       image = result["thumbnail"]["source"]

#       # Navigue dans la structure JSON pour obtenir l'extrait
#       pages = data["query"]["pages"]
#       page = pages.values.first

#       if page && result && image
#         p "summary and image"
#         fetched_data = { summary: result["extract"], image: image }
#       elsif page && result
#         p "only summary"
#         fetched_data = { summary: result["extract"] }
#       else
#         puts "Aucun extrait trouvé pour le titre : #{correct_title}"
#         return nil
#       end
#     else
#       puts "Réponse vide de l'API pour le titre : #{correct_title}"
#       return nil
#     end
#   else
#     puts "Titre invalide ou vide : #{title}"
#     return nil
#   end
# end

# # Ne fonctionne pas, sans raison
# def fetch_wikipedia_coordinates(title)
#   if title && !title.empty?
#     # Construction de l'URL pour l'Action API de Wikipédia
#     api_url = URI("https://fr.wikipedia.org/w/api.php")

#     # Définition des paramètres pour obtenir les coordonnées
#     params = {
#       format: 'json',
#       action: 'query',
#       prop: 'coordinates',
#       titles: title,
#       redirects: 1           # Redirige vers une orthographe plausible si besoin
#     }

#     # Construction de la requête avec les paramètres
#     api_url.query = URI.encode_www_form(params)

#     # Appel à l'API avec le bon titre
#     response = Net::HTTP.get(api_url)

#     unless response.empty?
#       data = JSON.parse(response)

#       # Navigue dans la structure JSON pour obtenir les coordonnées
#       pages = data["query"]["pages"]
#       page = pages.values.first

#       if page && page["coordinates"]
#         coordinates = page["coordinates"].first
#         latitude = coordinates["lat"]
#         longitude = coordinates["lon"]
#         return { latitude: latitude, longitude: longitude }
#       else
#         puts "Aucune coordonnée trouvée pour le titre : #{title}"
#         return nil
#       end
#     else
#       puts "Réponse vide de l'API pour le titre : #{title}"
#       return nil
#     end
#   else
#     puts "Titre invalide ou vide : #{title}"
#     return nil
#   end
# end

# result = fetch_wikipedia_summary("belle ile en mer")
# if result.present?
#   summary = result[:summary]

#   if result[:image].present?
#     image_url = result[:image]
#   end
# end


WikipediaService.new("Meribel").fetch_wikipedia_summary
