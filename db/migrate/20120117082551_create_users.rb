class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
			t.string :name
      t.timestamps
    end

		create_table :follows do |t|
			t.integer :owner_id
			t.integer :user_id
		end
		
		add_index :follows, :owner_id			
		add_index :follows, :user_id
  end
end
