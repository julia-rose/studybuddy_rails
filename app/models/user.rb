class User < ActiveRecord::Base
	has_many :decks, dependent: :destroy
	has_many :games, dependent: :destroy

	before_create :create_remember_token
	before_save :normalize_fields

	validates :name,
		presence: true,
		length: {maximum: 50}

	validates :email,
		presence: true,
		uniqueness: {case_sensitive:false},
		format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}

	validates :password,
		length: { minimum: 8}

	has_secure_password

	#Create a new remember token for a user:
	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	#Hash a token
	def User.hash(token)
		Digest::SHA1.hexdigest(token.to_s)
		
	end

	def add_deck
	name = gets().chomp()
	description = gets().chomp()
	@deck = self.decks.create(name: name, description: description)
	end

	def edit_deck
	@deck = get_deck
	if @deck == nil
		return
	else
		@deck.list_cards
		program_puts("(Add) a new card, (Update) an existing card, or (Delete) a card")
		program_puts("Or (Back) to the main menu")
		input = gets().chomp().downcase()
			case input
				when "add"
					@deck.add_card
				when "update"
					@deck.update_card
				when "delete"
					@deck.remove_card
				when "back"
					
				else
					program_puts("I don't know what you're trying to tell me!")
			end
		end
	end

	def list_my_decks
		if self.decks.count == 0
			program_puts("You haven't made any decks yet!")
		else
			program_puts("Listing all your decks:")
			puts("")
			self.decks.each do |deck|
				program_puts("ID: #{deck.id} // Created by: #{User.find(deck.user_id).name}")
				program_puts("Name: #{deck.name}")
				program_puts("Description: #{deck.description}")
				program_puts("---")
			end
		end
	end

	def resume_game
		program_puts("#{name}'s Games In Progress")
		program_puts("---")
		games.each do |game|
			if game.paused_at != nil
				program_puts("(ID: #{game.id}) #{game.timestamp} // Deck: #{game.deck.name} // Correct answers so far: #{game.total_correct} // Incorrect answers so far: #{game.missed.count}")
				@paused_game_exists = "yes"
			end
		end

		if @paused_game_exists != "yes"
			program_puts("Psych!!! You don't have any games in progress!")
		else
			program_puts("Which game? Type its ID to resume.")
			input = gets().chomp().to_i()
			@game = Game.find(input)
			start_again(@game)
		end
	end

	def start_again(game)
		@game = game
		@deck = Deck.find(@game.deck_id)
		start_index = @game.paused_at 
		catch (:done)  do
			@deck.cards.each_with_index do |card, index|
				if index < start_index 
					puts("Skipping...")
				elsif index >= start_index
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
			end
			@deck.end_game(@game)
		end
	end

	def history
		program_puts("#{name}'s Recent Games")
		program_puts("---")

		if games.count == 0
			program_puts("Your history is empty because you haven't played any games yet!")
		else
			games.each do |game|
				program_puts(">> #{game.timestamp} // Deck: #{Deck.find(game.deck_id).name} // Correct answers: #{game.total_correct} // Incorrect answers: #{game.missed.count}")
			end
		end
	end

	private

	#Create a new session token for the user
	def create_remember_token
		remember_token = User.hash(User.new_remember_token)
	end

	#Normalize fields for consistency
	def normalize_fields
		self.email.downcase!
	end
end
