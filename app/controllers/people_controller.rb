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
    #check the answer to see if it's already in the session
      if session[:answers].include?(person)
        # We got a cheater on our hands...
        session[:answers] = nil
        flash['alert'] = "Sorry, but you already entered #{person}. Final score: #{current_user.rounds.last.score}"
        redirect_to root_path
      else
      	# First returns true if the person is present in the DB
        person = Person.lookup_person_in_db(person)
        if !person
          # The person does not exist in the DB and was therefore not in the move that brought us here
          session[:answers] = nil
          flash['alert'] = "Sorry, but we could not find anyone by the name of #{person}. Final score: #{current_user.rounds.last.score}"
          redirect_to root_path
        elsif person.validate_movie(movie) == true
          # Returns true if the person is in the movie that the user put in
    			@user.update_score
    			@user.update_level_up
          session[:answers] << person
    			redirect_to new_movie_path(:person => person)
          flash['notice'] = "Correct! #{person} was in #{movie}."
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
