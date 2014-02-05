class RoundsController < ApplicationController

  def index
    @rounds = Round.all(order: 'score DESC', limit: 10 )
    #@usernames = @rounds.each {|user| User.find(user_id).username }
    #@users = User.all
  end

  def show
  end

  def new
    @round = Round.new
    #redirect_to new_user_round_path
  end

  def create
  	@round = current_user.rounds.create!
  	if @round.save
  		redirect_to :controller => :movies, :action => :new
  	else
  		render :controller => :users, :action => :index
  	end
  end

  def update
  	@round = @round

  end

  private

  def round_params
    params.require(:round).permit(:user_id)
  end
end
