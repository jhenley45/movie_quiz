class PeopleController < ApplicationController

  def index
  end

  def show
  end

  def create
  	person = params[:person]["name"]
  	movie = params[:person]["movie"]
  	binding.pry
  	# First returns true if the person is present in the DB
  	# Second returns true if the person is in the movie that the user put in
  	if Person.find_by_name(person) == true && Person.validate_movie(person, movie) == true
  		redirect_to new_movie_path(:person => person)
  	else
  		#Wrong Answer, round is over
  	end

  end

  def new
  	@person = Person.new
  	@movie = params[:movie]
  	binding.pry
  end

end
