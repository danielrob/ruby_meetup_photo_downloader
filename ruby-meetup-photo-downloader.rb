require 'httparty'
debug = false
# This script will download all images at full resolution from a Meetup.com event.
# It requires ruby with rubygems to be installed. 
# Fill out the API_KEY below, then use Terminal to ensure you have the httparty gem installed and then run the script:
# sudo gem install httparty
# ruby ruby-meetup-photo-downloader.rb "123456789" "/Users/daniel/Pictures/meetupdownload" 

# Get your API Key at http://www.meetup.com/meetup_api/key/
API_KEY = "y0urAP1K3Y"
# The event id. Something like http://www.meetup.com/GROUPNAME/events/123456789/
EVENT_ID = ARGV[0].to_s
# Path to save the photos. Ensure this path exists. 
PATH = ARGV[1].to_s 

# Get the photo's for the event id, and store the response. Max 200 results. 
response = HTTParty.get("https://api.meetup.com/2/photos?key=#{API_KEY}&event_id=#{EVENT_ID}&page=200")
puts response if debug # if you get a nill error ensure your event id is correct!
# Loops through all the results, making a request for each high_res photo, and saving that photo to the specified directory
(0..response["results"].length).each do |result|
  result_info = response["results"][result]
  highres_photo_link = result_info["highres_link"]
  member_name = result_info["member"]["name"]
  # Photos are named e.g. 0-Danny.jpeg, 1-Susan.jpeg. jpeg is assumed. 
  File.open("#{PATH}/#{result}-#{member_name}.jpeg", "wb") do |f|
    f.write HTTParty.get(highres_photo_link).parsed_response
  end
end

