class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
    	t.belongs_to :deck
			t.string :q
			t.string :a
    end
  end
end
