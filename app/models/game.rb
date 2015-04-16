class Game < ActiveRecord::Base
	belongs_to :deck
	belongs_to :user
	validates :user, presence: true
	validates :deck, presence: true

	def summarize
		if missed.count == 0
			program_puts("Congratulations! You know these cards perfectly!")
			program_puts("***")
		elsif total_correct == 0
			program_puts("Well, you didn't get any of these, but that's why we're studying!")
			program_puts("***")
		else
			program_puts("All done! You got #{total_correct} cards correct and only missed #{missed.count}.")
			program_puts("***")
		end
	end

end