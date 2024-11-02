require 'net/http'
require 'json'
require 'uri'

def fetch_wikipedia_summary(title)
  if title.present?
    correct_title = title

    # Construction de l'URL pour l'Action API de Wikipédia
    api_url = URI("https://fr.wikipedia.org/w/api.php")

    # Définition des paramètres pour obtenir un extrait complet et les coordonnées
    params = {
      format: 'json',
      action: 'query',
      prop: 'extracts|coordinates',
      exintro: 1,
      explaintext: 1,
      redirects: 1,           # Redirige vers une orthographe plausible
      titles: correct_title,
      exsectionformat: 'plain' # Format des sections en texte brut
    }

    # Construction de la requête avec les paramètres
    api_url.query = URI.encode_www_form(params)

    # Appel à l'API avec le bon titre
    summary_response = Net::HTTP.get(api_url)

    unless summary_response.empty?
      data = JSON.parse(summary_response)

      # p data

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
    puts "Titre invalide ou vide : #{title}"
    return nil
  end
end

p fetch_wikipedia_summary("belle ile en mer")
