class UsersController < ApplicationController

	before_action :authenticate_user!

	def index
		@users = User.all

	end

	def show
		@rounds = User.find(params[:id]).rounds.all(order: 'score DESC', limit: 10 )
		@user = User.find(params[:id])
	end

end
