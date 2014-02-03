class CastsController < ApplicationController

  def show
  end

  def index
  	if params[:movie].present?
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
	  	@answer = name_check(@correct_name, @names)

 		end
  end

  def create
  end

  def new
  end


  private

  def name_check(name, cast)
  	if cast.include?(name)
  		"Correct. That person is in that movie"
  	else
  		"Incorrect. Actor/actress not in that movie"
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
