class CreateMissions < ActiveRecord::Migration
  def change
    create_table :missions do |t|
    	t.column :name, :string
    	t.column :launch_date, :date
    	t.column :launch_time, :datetime
    	t.column :description, :text    	
    	t.column :active, :boolean, :default => false
      t.column :mode, :string
      t.timestamps
    end
  end
end
