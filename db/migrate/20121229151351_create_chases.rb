class CreateChases < ActiveRecord::Migration
  def change
    create_table :chases do |t|
    	t.column :lat, :double
    	t.column :lon, :double
    	t.column :mission_id, :integer
      	t.timestamps
    end
  end
end
