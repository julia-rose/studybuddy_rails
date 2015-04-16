class CreateDecks < ActiveRecord::Migration
  def change
    create_table :decks do |t|
    	t.belongs_to :user
			t.string :name
			t.string :description
    end
  end
end
