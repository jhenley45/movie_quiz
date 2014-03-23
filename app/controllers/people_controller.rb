class PeopleController < ApplicationController
  before_action :authenticate_user!
  before_filter :get_user

  def index
  end

  def create
  	person = params[:person]["name"]
  	movie = params[:person]["movie"]
    #Check to see if the user is trying to replay the round
    if !session[:answers].nil?
      if session[:answers].include?(person)
        # We got a cheater on our hands...
        session[:answers] = nil
        flash['alert'] = "Sorry, but you already entered #{person}. Final score: #{current_user.rounds.last.score}"
        redirect_to root_path
      else
        db_person = Person.lookup_person_in_db(person)
        if !db_person # user's answer is not in our DB. Wrong answer
          session[:answers] = nil
          flash['alert'] = "Sorry, but we could not find anyone by the name of #{person}. Final score: #{current_user.rounds.last.score}"
          redirect_to root_path
        elsif db_person.validate_movie_for_person(movie) == true
    			@user.update_score
    			@user.update_level_up
          session[:answers] << person
    			redirect_to new_movie_path(:person => db_person.name)
          flash['notice'] = "Correct! #{db_person.name} was in #{movie}."
  	  	else
          # the person exists but is not in this movie
          session[:answers] = nil
	  			flash['alert'] = "Sorry, but #{person} was not in #{movie}. Final score: #{current_user.rounds.last.score}"
	  			redirect_to root_path
      	end
      end
    else
      flash['alert'] = "Cheating is bad for your health."
      redirect_to root_path
    end
  end

  def new
  	@person = Person.new
    if current_user.rounds.last.level < 5
      @initial_time = 22 - (current_user.rounds.last.level * 2)
    else
      @initial_time = 15
    end
  	@movie = params[:movie]
  end

end
