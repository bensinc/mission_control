class Packet < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :mission


	RAD_PER_DEG = 0.017453293
	Rmiles = 3956

  def distance_to(packet)
  	return(self.haversine_distance(self.lat, self.lon, packet.lat, packet.lon))
  end

  def altitude_ft
  	return self.altitude * 3.28084
  end



end


def haversine_distance( lat1, lon1, lat2, lon2 )

dlon = lon2 - lon1

dlat = lat2 - lat1

 

dlon_rad = dlon * RAD_PER_DEG

dlat_rad = dlat * RAD_PER_DEG

 

lat1_rad = lat1 * RAD_PER_DEG

lon1_rad = lon1 * RAD_PER_DEG

 

lat2_rad = lat2 * RAD_PER_DEG

lon2_rad = lon2 * RAD_PER_DEG

 


a = (Math.sin(dlat_rad/2))**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * (Math.sin(dlon_rad/2))**2

c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a))

dMi = Rmiles * c          # delta between the two points in miles

	return(dMi)
end
