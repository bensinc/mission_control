class Mission < ActiveRecord::Base
  
  attr_accessible :name, :active, :description, :launch_date, :payload_weight, :balloon_type, :lifting_gas, :recovery_status

  has_many :packets, :order => 'created_at desc'
  has_many :spots, :order => 'unixtime desc'

  def latest_primary
  	self.packets.find(:first, :order => 'id desc', :limit => 1)
  end

  def latest_secondary
  	self.spots.find(:first, :order => 'id desc', :limit => 1)
  end

  def update_mode
    return if self.packets.size < 3

  	if latest_primary.altitude * 3.28084 > 1500 and self.mode == 'countdown'
  		self.mode = 'ascending'
  		self.launch_time = Time.now
  		self.save
  		return
  	end

  	last_three = self.packets.find(:all, :order => 'created_at desc', :limit => 3)
  	
  	if last_three[0].altitude < last_three[1].altitude and last_three[1].altitude < last_three[2].altitude
  		self.mode = 'descending'
      
      unless self.burst_alt
        highest = Packet.find(:first, :conditions => ["mission_id = ?", self.id], :order => 'altitude desc', :limit => 1)
        logger.debug "HIGHEST: #{highest.altitude_ft}"
        self.burst_alt = highest.altitude
        self.burst_lat = highest.lat
        self.burst_lon = highest.lon
      end
  		 self.save
  		return
  	end

  	if (self.mode == 'descending' and last_three[2].distance_to(last_three[0]) < 1 and last_three[0].altitude * 3.28084 < 2000)
  		self.mode = 'landed'
      self.land_time = Time.now
  		self.save  		
  		return
  	end  	
  end


end
