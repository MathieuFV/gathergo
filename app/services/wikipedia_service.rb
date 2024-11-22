class WikipediaService
  def initialize(destination_name, language)
    @destination_name = destination_name
    @language = language
  end

  def fetch_wikipedia_summary
    if @destination_name.present?
      # Construction de l'URL pour l'Action API de Wikipédia
      api_url = URI("https://#{@language}.wikipedia.org/w/api.php")

      # Définition des paramètres pour obtenir un extrait complet et les coordonnées
      params = {
        action: 'query',
        format: 'json',
        prop: 'extracts|coordinates',
        exintro: 1,
        explaintext: 1,
        redirects: 1,           # Redirige vers une orthographe plausible
        titles: @destination_name,
        exsectionformat: 'plain' # Format des sections en texte brut
      }

      # Construction de la requête avec les paramètres
      api_url.query = URI.encode_www_form(params)

      # Appel à l'API avec le bon titre
      summary_response = Net::HTTP.get(api_url)

      unless summary_response.empty?
        data = JSON.parse(summary_response)
        image_data = data

        # Vérification de la présence de query & page
        if data.dig("query", "pages")
          result = data["query"]["pages"].values.first
          # Navigue dans la structure JSON pour obtenir l'extrait
          pages = data["query"]["pages"]
          page = pages.values.first
        end

        if page && result
          fetched_data = { summary: result["extract"], coordinates: result["coordinates"] }
        else
          puts "Aucun extrait trouvé pour le titre : #{@destination_name}"
          return nil
        end
      else
        puts "Réponse vide de l'API pour le titre : #{@destination_name}"
        return nil
      end
    else
      puts "Titre invalide ou vide : #{@destination_name}"
      return nil
    end
  end

end
