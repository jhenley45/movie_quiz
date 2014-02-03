class CastsController < ApplicationController

  def show
  end

  def index
  	if params[:movie].present?
	  	@movie = params[:movie]
	  	@cast = Cast.find_cast(@movie)
	  	@movie_names = Tmdb::Movie.find(@movie)
 		end
  end

  def create
  end

  def new
  end
end
