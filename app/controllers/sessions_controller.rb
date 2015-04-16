class SessionsController < ApplicationController

	def new
	end

	def create
		#find the user by their email
		user = User.find_by(email: params[:session][:email].downcase)

		#testing if the user was found AND authenticate
		if user && user.authenticate(params[:session][:password])
			sign_in(user)
			redirect_back_or root_path
		else
			flash[:error] = "Invalid email/password"
			redirect_to new_session_path
		end
	end

	def destroy
	  sign_out
	  redirect_to signin_path
	end

end