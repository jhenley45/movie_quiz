class RoundsController < ApplicationController
  def index
  end

  def show
  end

  def new

  end

  def create
  	@round = current_user.rounds.create!
  	if @round.save
  		redirect_to :controller => :movies, :action => :index
  	else
  		render :controller => :users, :action => :index
  	end
  end

  def update
  	@round = @round

  end
end
