class PeopleController < ApplicationController

  def index
  end

  def show
  end

  def create
  	person = params[:person]["name"]
  	movie = params[:person]["movie"]
  	# First returns true if the person is present in the DB
  	# Second returns true if the person is in the movie that the user put in
  	if Person.find_by_name(person) == true
  		if Person.validate_movie(person, movie) == true
  			update_score
  			update_level_up
  			redirect_to new_movie_path(:person => person)
        flash['notice'] = "Correct! #{person} was in #{movie}."
	  	else
	  			# this person is not in the movie
	  			flash['alert'] = "Sorry, but #{person} is not in #{movie}. Final score: #{current_user.rounds.last.score}"
	  			# end round
	  			redirect_to root_path
  		end
  	else
  			flash['alert'] = "Sorry, \"#{person}\" does not match any of our records. Final score: #{current_user.rounds.last.score}"
  			# end round
  			redirect_to root_path
  	end
  end

  def new
  	@person = Person.new
  	@movie = params[:movie]
  end

end
