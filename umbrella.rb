require "http"
require "json"

pp "Where are you located?"

user_location = gets.chomp.gsub(" ", "%20")

# pp user_location = "Chicago"

pp "Current location: " + user_location.gsub("%20", " ")

maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + ENV.fetch("GMAPS_KEY")

resp = HTTP.get(maps_url)

raw_response = resp.to_s

parsed_response = JSON.parse(raw_response)

results = parsed_response.fetch("results")

first_result = results.at(0)

geo = first_result.fetch("geometry")

loc = geo.fetch("location")

latitude = loc.fetch("lat")
longitude = loc.fetch("lng")

# pp "Latitude: " + latitude.to_s + ", Longitude: " + longitude.to_s

# # pp ENV.fetch("GMAPS_KEY")
pirate_weather_api_key = ENV.fetch("PIRATE_WEATHER_KEY")

# # I've already created a string variable above: pirate_weather_api_key
# # It contains sensitive credentials that hackers would love to steal so it is hidden for security reasons.

# require "http"

# # Assemble the full URL string by adding the first part, the API token, and the last part together
pirate_weather_url = "https://api.pirateweather.net/forecast/" + pirate_weather_api_key + "/" + latitude.to_s + "," + longitude.to_s

# # Place a GET request to the URL
raw_response = HTTP.get(pirate_weather_url)

# require "json"

parsed_response = JSON.parse(raw_response)

currently_hash = parsed_response.fetch("currently")

current_temp = currently_hash.fetch("temperature")

hourly_hash = parsed_response.fetch("hourly")

hourly_summary = hourly_hash.fetch("summary")

# current_summary = currently_hash.fetch("summary")

puts "The current temperature is " + current_temp.to_s + ". " + "Weather for the next hour predicted to be " + hourly_summary + "."
