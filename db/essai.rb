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

  if title.present?
    correct_title = title

    # Construction de l'URL pour l'Action API de Wikipédia
    api_url = URI("https://fr.wikipedia.org/w/api.php")

    # Définition des paramètres pour obtenir un extrait complet
    params = {
      format: 'json',
      action: 'query',
      prop: 'extracts',
      exintro: 1,
      explaintext: 1,
      redirects: 1,          # Permet de rediriger vers une orthographe plausible
      titles: correct_title,
      exsectionformat: 'plain',# Format des sections en texte brut
      # exchars: 2000            # Nombre maximum de caractères dans l'extrait
    }

    # Construction de la requête avec les paramètres
    api_url.query = URI.encode_www_form(params)

    # Appel à l'API avec le bon titre
    summary_response = Net::HTTP.get(api_url)

    unless summary_response.empty?
      data = JSON.parse(summary_response)

      # Navigue dans la structure JSON pour obtenir l'extrait
      pages = data["query"]["pages"]
      page = pages.values.first

      if page && page["extract"]
        return page["extract"]
      else
        puts "Aucun extrait trouvé pour le titre : #{correct_title}"
        return nil
      end
    else
      puts "Réponse vide de l'API pour le titre : #{correct_title}"
      return nil
    end
  else
    puts "Aucune suggestion trouvée pour le titre : #{title}"
    return nil
  end
end

# def fetch_wikipedia_summary(title)
#   suggestions = fetch_correct_wikipedia_name(title)

#   puts suggestions

#   # # Vérifie si une suggestion est bien renvoyée
#   if suggestions[1].any?

#     puts suggestions[1].first
#     # # Utilise le premier résultat comme le titre correct
#     correct_title = suggestions[1].first

#     # # On formate le titre pour l'API REST wikipedia
#     formatted_title = correct_title.gsub(" ", "_")
#     encoded_correct_title = URI.encode_www_form_component(formatted_title)
#     summary_url = URI("https://fr.wikipedia.org/api/rest_v1/page/summary/#{encoded_correct_title}")

#     # # Appel à l'API avec le bon titre
#     summary_response = Net::HTTP.get(summary_url)
#     if !summary_response.empty?
#       data = JSON.parse(summary_response)
#       # Si on reçoit bien de la donnée :
#       if data["extract"]
#         data["extract"]
#       end
#     end
#   end
# end

p fetch_wikipedia_summary("meribel")
