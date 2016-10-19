require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]
    @street_address_without_spaces = URI.encode(@street_address)

    # ==========================================================================
    # Your code goes below.
    # The street address the user input is in the variable @street_address.
    # A URL-safe version of the street address, with spaces and other illegal
    #   characters removed, is in the variable @street_address_without_spaces.
    # ==========================================================================

    #Extract latitude and longitude
    url_location = "http://maps.googleapis.com/maps/api/geocode/json?address=#{@street_address_without_spaces}&sensor=false"
    parsed_data_location = JSON.parse(open(url_location).read)


    latitude = parsed_data_location["results"][0]["geometry"]["location"]["lat"]

    longitude = parsed_data_location["results"][0]["geometry"]["location"]["lng"]

    #Get weather

    url_weather = "https://api.darksky.net/forecast/dc8722d21a1ac525274d727de7757a0e/#{latitude},#{longitude}"
    parsed_data_weather = JSON.parse(open(url_weather).read)



    @current_temperature = parsed_data_weather["currently"]["temperature"]

    @current_summary = parsed_data_weather["currently"]["summary"]

    @summary_of_next_sixty_minutes = parsed_data_weather["minutely"]["summary"]

    @summary_of_next_several_hours = parsed_data_weather["hourly"]["summary"]

    @summary_of_next_several_days = parsed_data_weather["daily"]["summary"]

    render("meteorologist/street_to_weather.html.erb")
  end
end
