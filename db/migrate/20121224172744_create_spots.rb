class CreateSpots < ActiveRecord::Migration
  def change
    create_table :spots do |t|
    	t.column :message_id, :string
    	t.column :lat, :double
    	t.column :lon, :double
    	t.column :unixtime, :string
    	t.column :mission_id, :integer    	    
      t.timestamps
    end
  end
end
