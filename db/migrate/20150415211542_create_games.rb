class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
    	t.belongs_to :user
			t.belongs_to :deck
			t.integer :total_correct
			t.integer :missed, array: true, default: []
			t.integer :paused_at, default: nil
			t.datetime :timestamp, default: Time.now
    end
  end
end
