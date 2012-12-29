class MainController < ApplicationController

  def index
  	@mission = Mission.find(:first, :conditions => "active is true", :order => 'launch_date desc')
  	@mission.update_mode
  	@primary = @mission.latest_primary
  	@secondary = @mission.latest_secondary
  	@chase = Chase.find(:first, :order => 'created_at desc');

  end

end
