class MoviesController < ApplicationController


  def show
  end

  def index
  	if params[:person].present?
  		person = params[:person]
  		@movies = Movie.find_movie(person)
  	end

	end


  def create
  end

  def new
  end
end
