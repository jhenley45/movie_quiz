class PeopleController < ApplicationController


  def index
  end

  def show
  end

  def create
  	person = params[:person]["name"]
  	movie = params[:person]["movie"]
    #check the answer to see if it's already in the session
    if session[:answers].include?(person)
      session[:answers] = nil
      flash['alert'] = "Sorry, but you already entered #{person}. Final score: #{current_user.rounds.last.score}"
      # end round
      redirect_to root_path
    else
    	# First returns true if the person is present in the DB
    	# Second returns true if the person is in the movie that the user put in
    	if Person.find_by_name(person) == true
    		if Person.validate_movie(person, movie) == true
    			update_score
    			update_level_up
          session[:answers] << person
    			redirect_to new_movie_path(:person => person)
          flash['notice'] = "Correct! #{person} was in #{movie}."
  	  	else
            session[:answers] = nil
  	  			# this person is not in the movie
  	  			flash['alert'] = "Sorry, but #{person} is not in #{movie}. Final score: #{current_user.rounds.last.score}"
  	  			# end round
  	  			redirect_to root_path
    		end
    	else
          session[:answers] = nil
    			flash['alert'] = "Sorry, \"#{person}\" does not match any of our records. Make sure you didn't make any spelling errors. Final score: #{current_user.rounds.last.score}"
    			# end round
    			redirect_to root_path
    	end
    end
  end

  def new
  	@person = Person.new
    @initial_time = 12 - (current_user.rounds.last.level * 2)
  	@movie = params[:movie]
  end

end
