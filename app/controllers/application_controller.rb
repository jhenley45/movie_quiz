class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?


  def update_score
  	#get the current round for the user
  		@round = current_user.rounds.last
  		#increment the score
  		@round.score += 5
  		#save the new score
  		@round.save
  end

  def update_level_up
  	@round = current_user.rounds.last
  	@round.level_up += 1
  	if @round.level_up == 5
  		@round.level += 1
  		@round.level_up = 0
  	end
  	@round.save
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :username
  end
end
