require "http"
require "json"
require "cgi"

puts "========================================"
puts "Will you need an umbrella today?"
puts "========================================
\n"

puts "Where are you located?"
# user_location = gets.chomp.gsub(" ", "%20")
user_location = gets.chomp

encoded_location = CGI.escape(user_location)

# puts "Checking the weather at " + user_location.gsub("%20", " ") + "...."
puts "Checking the weather at #{user_location}...."

maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + ENV.fetch("GMAPS_KEY")

# resp = HTTP.get(maps_url)
# raw_response = resp.to_s

parsed_response = JSON.parse(HTTP.get(maps_url))

# results = parsed_response.fetch("results")
# first_result = results.at(0)

first_result = parsed_response.fetch("results").at(0)

# geo = first_result.fetch("geometry")
# loc = geo.fetch("location")

loc = first_result.fetch("geometry").fetch("location")
latitude = loc.fetch("lat").to_s
longitude = loc.fetch("lng").to_s

puts "Your coordinates are #{latitude}, #{longitude}"

pirate_weather_api_key = ENV.fetch("PIRATE_WEATHER_KEY")
# Assemble the full URL string by adding the first part, the API token, and the last part together
pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_api_key}/#{latitude},#{longitude}"

# Place a GET request to the URL
# raw_response = HTTP.get(pirate_weather_url)

parsed_response = JSON.parse(HTTP.get(pirate_weather_url))

currently_hash = parsed_response.fetch("currently")
current_temp = currently_hash.fetch("temperature")
hourly_hash = parsed_response.fetch("hourly")
hourly_summary = hourly_hash.fetch("summary")

puts "It is currently #{current_temp}°F." 
puts "Next hour: #{hourly_summary}."

hourly_data = hourly_hash.fetch("data")
will_need_umbrella = false

hourly_data[0..11].each_with_index do |hour_data, index|
  precipitation_probability = hour_data.fetch("precipProbability")
  if precipitation_probability > 0.1
    will_need_umbrella = true
    puts "There's a high chance (#{precipitation_probability * 100}%) of precipitation in #{index + 1} hour(s)."
  else
    puts "There's a low chance (#{precipitation_probability * 100}%) of precipitation in #{index + 1} hour(s)."
  end
end

if will_need_umbrella
  puts "You might need an umbrella today!"
else
  puts "You probably won't need an umbrella today."
end
