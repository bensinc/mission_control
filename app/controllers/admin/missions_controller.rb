class Admin::MissionsController < ApplicationController
  
  def index
  	@missions = Mission.all(:order => 'launch_date desc')
  end

  def edit
  	  @mission = Mission.find(params[:id])
  end

  def new
  	@mission = Mission.new
  end

  def update
  	  @mission = Mission.find(params[:id])
      @mission.attributes = params[:mission]
  	  @mission.save
  	  redirect_to :action => 'index' and return
  end

  def create
  	@mission = Mission.new(params[:mission])
  	@mission.save
  	redirect_to :action => 'index' and return
  end

  def destroy
  	@mission = Mission.find(params[:id])
  	@mission.destroy
  	flash[:success] = 'Mission removed!'
  	redirect_to :action => 'index' and return
  end

end
