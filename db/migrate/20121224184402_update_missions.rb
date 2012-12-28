class UpdateMissions < ActiveRecord::Migration
  def up
  	add_column :missions, :payload_weight, :string
  	add_column :missions, :balloon_type, :string
  	add_column :missions, :lifting_gas, :string
  	add_column :missions, :land_time, :datetime
  end

  def down
  end
end
