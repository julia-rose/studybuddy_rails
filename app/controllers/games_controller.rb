class GamesController < ApplicationController

	def index
		@games = User.find(params[:user_id]).games
	end

end