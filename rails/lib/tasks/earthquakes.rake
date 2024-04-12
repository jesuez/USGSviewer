desc "Gets obtain seismological data from the USGS site (earthquake.usgs.gov)."
task earthquakes: [:environment] do
  	puts "Gathering seismic information"
	require 'json'
	http_path = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson"
	result = JSON.parse(
		`curl -X GET #{http_path}` 
	)


  	result["features"].each do |item|

		if !item["properties"]["title"]
			next
		end
		if !item["properties"]["url"]
			next
		end
		if !item["properties"]["place"]
			next
		end
		if !item["properties"]["magType"]
			next
		end
		if !item["geometry"]["coordinates"][0] || !item["geometry"]["coordinates"][1] 
			next
		end
		if item["properties"]["mag"] < -1 || item["properties"]["mag"] > 10 
			next
		end
		if item["geometry"]["coordinates"][0] > 180 || item["geometry"]["coordinates"][0] < -180 
			next
		end
		if item["geometry"]["coordinates"][1] > 90 || item["geometry"]["coordinates"][1] < -90
			next
		end
		if Feature.where(external_id: item["id"]).exists?
			#puts item["id"]+' Already exists'
			next
		end

		Feature.create(external_id: item["id"],
						   type: item["type"]  ,
					      magnitude: item["properties"]["mag"]  ,
					      mag_type: item["properties"]["magType"]  ,
					      place: item["properties"]["place"]  ,
					      time: item["properties"]["time"]  ,
					      url: item["properties"]["url"]  ,
					      tsunami: item["properties"]["tsunami"]  ,
					      title: item["properties"]["title"]  ,
					      latitude: item["geometry"]["coordinates"][1],
					      longitude: item["geometry"]["coordinates"][0],
					      )
		
		puts "Storing feature: "+item["id"]
	end
	puts 'DONE.'
end