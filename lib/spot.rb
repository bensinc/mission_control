require '../config/environment.rb'
require 'open-uri'
require 'json'



URL = 'https://api.findmespot.com/spot-main-web/consumer/rest-api/2.0/public/feed/0IfQlWhfqa5CzMn8YY8kOd5SmKpaIgUQY/message.json'

result = JSON.parse(open(URL).read)

for message in result['response']['feedMessageResponse']['messages']
	# for key in message
	# 	puts "#{key}: #{message[]}"
	# end
	for item in message
		if item.class == Array
			for i in item
				if i.class == Hash
					s = Spot.new
					s.message_id = i['id']
					s.unixtime = i['unixTime']
					s.lat = i['latitude']
					s.lon = i['longitude']
					s.mission_id = 1
					if s.save
						puts "New Spot position!"
					end
					# for key in i.keys
					# 	puts "#{key}: #{i[key]}"
					# end
				end
				
			end
		end
	end
	

end