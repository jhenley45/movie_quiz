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
 		end
  end

  def create
  end

  def new
  end
end
