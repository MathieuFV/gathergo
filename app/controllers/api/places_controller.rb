class Api::PlacesController < ApplicationController
  def autocomplete
    url = "https://maps.googleapis.com/maps/api/place/queryautocomplete/json"
    response = HTTP.get(url, params: {
      input: params[:input],
      key: ENV['GOOGLE_GEOCODING_API_KEY'],
      types: '(cities)'
    })

    render json: response.parse
  end
end 