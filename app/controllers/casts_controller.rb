class CastsController < ApplicationController

  def show
  end

  def index
  	if params[:movie].present? && params[:correct_name].present?
	  	@movie = params[:movie]
	  	#find the cast for this movie
	  	@cast = Cast.find_cast(@movie)

	  	# get the title of the movie to be passed into the movies controller in correct format
	  	@movie_names = Tmdb::Movie.find(@movie)
	  	#get the first search result
	  	@movie_name = @movie_names.first.original_title


	  	# Get the clean actor/actress name from the params
	  	@correct_name = params[:correct_name]
	  	#get an array of all of the cast names
	  	@names = name_array(@cast)
	  	#determine if the user input is in this array
	  	@answer = name_check(@correct_name, @names, @movie_name)
	  else
	  	@movie = params[:movie]
	  	#find the cast for this movie
	  	@cast = Cast.find_cast(@movie)

	  	# get the title of the movie to be passed into the movies controller in correct format
	  	@movie_names = Tmdb::Movie.find(@movie)
	  	#get the first search result
	  	@movie_name = @movie_names.first.original_title
 		end

  end

  def create
  end

  def new
  end


  private

  def name_check(name, cast, movie_name)
  	if cast.include?(name)
  		#get the current round for the user
  		@round = current_user.rounds.last
  		#increment the score
  		@round.score += 5
  		#save the new score
  		@round.save
  		#return message to print
  		"Correct, #{name} was in #{movie_name}."

  	else
  		"Incorrect, #{name} was not in #{movie_name}."
  	end
  end

  def name_array(cast)
  	names = []
  	cast.each do |person|
  		names << person["name"]
  	end
  	names
  end
end
