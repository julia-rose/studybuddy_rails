class Deck < ActiveRecord::Base
	has_many :cards, dependent: :destroy
	has_many :games, dependent: :destroy
	belongs_to :user
	validates :name, presence: true

	def list_cards
		if cards.empty?
			program_puts("This deck is empty!")
			program_puts("***")
		else
			program_puts("Deck: #{self.name}")
			program_puts("Listing Q-side cards for this deck:")
			puts("")
			cards.each do |card|
				puts("-#{card.q}".indent(8))
			end
			program_puts("***")
		end
	end

	def add_card(q = nil, a = nil)
		if q == nil
			program_puts("Enter the Q-side or 'question' for this card.")
			q = gets().chomp().to_s()
		end
		if a == nil
			program_puts("Enter the A-side or 'answer' for this card.")
			a = gets().chomp().to_s()
		end
		cards << Card.new(q: q, a: a)

		program_puts("(Add) another card? Or (nah)")
		input = gets().chomp().downcase()
		if input == "add"
			add_card
		else
			program_puts("Ok cool.")
		end
	end

	def get_card(q = nil)
		if q == nil
			list_cards
			program_puts("Enter the Q-side or 'question' of the card.")
			card = gets().chomp().to_s()
		end
		cards.find_by(q: card)
	end


	def remove_card(q = nil)
		get_card.delete
	end

	def update_card(q = nil)
		if self.cards.count == 0
			program_puts("You can't update a card that doesn't exist yet!")
		else
			card = get_card
			program_puts("Update Q, A, or both?")
			input = gets().chomp().downcase

			if input == "q"
				program_puts("Enter the updated Q-side or 'question' for this card.")
				q = gets().chomp().to_s()
				card.update(q: q)
			elsif input == "a"
				program_puts("Enter the updated A-side or 'answer' for this card.")
				a = gets().chomp().to_s()
				card.update(a: a)
			elsif input == "both"
				program_puts("Enter the updated Q-side or 'question' for this card.")
				q = gets().chomp().to_s()
				program_puts("Enter the updated A-side or 'answer' for this card.")
				a = gets().chomp().to_s()
				card.update(q: q, a: a)
			else
				program_puts("I wasn't sure what you wanted to edit.")
			end
		end
	end

	def play(user_id)
		@game = Game.new(user_id: user_id, deck_id: id, total_correct: 0)
		program_puts("-----GAME START-----")
		program_puts(description)
		program_puts("(Pause) at any time; your progress will be saved.")
		iterate
	end

	def iterate
		catch (:done)  do
			cards.each_with_index do |card, index|
				program_puts("#{card.q}")
				input = gets().chomp().to_s().downcase()
				if input == card.a.downcase
					program_puts("Correct!")
					@game.total_correct = @game.total_correct + 1
				elsif input == "pause"
					@game.paused_at = index
					@game.save
					program_puts("Game paused! To resume, visit (resume) on the main menu.")
					throw :done
				else
					program_puts("Whoops...")
					@game.missed << card.id
				end
			end

			if @game.total_correct + @game.missed.count == cards.count
				end_game(@game)
			end
		end
	end

	def end_game(game)
		@game = game
		program_puts("-----GAME OVER-----")
		@game.update(timestamp: Time.now)
		@game.update(paused_at: nil)
		@game.save
		@game.summarize
	end

	def leaderboard
		program_puts("#{name} Leaderboard:")
		games.order(total_correct: :desc).each do |game|
			program_puts("#{User.find(game.user_id).name} got #{game.total_correct} correct answers on #{game.timestamp}!")
		end
	end

end