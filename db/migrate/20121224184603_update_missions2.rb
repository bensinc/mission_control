class UpdateMissions2 < ActiveRecord::Migration
  def up
  	add_column :missions, :recovery_status, :string
  	add_column :missions, :burst_lat, :double
  	add_column :missions, :burst_lon, :double
  	add_column :missions, :burst_alt, :double
  end

  def down
  end
end
