class Card < ActiveRecord::Base
	belongs_to :deck
	validates :deck, presence: true

end