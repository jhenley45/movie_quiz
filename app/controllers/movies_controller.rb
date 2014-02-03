class MoviesController < ApplicationController


  def show
  end

  def index
  	if params[:person].present?
  		person = params[:person]
  		#find all the movies for this person
  		@movies = Movie.find_movie(person)
  		#clean resulst
  		@movie = @movies.first[1]
  		#create array of titles
  		@titles = title_array(@movie)
  		#get the movie title from the params
  		@movie_name = params[:movie_name]
  		#determine if the user input matches the titles we have
  		@answer = movie_check(@movie_name, @titles)


  		@correct_name = Tmdb::Person.find(person).first.name

  	end

	end


  def create
  end

  def new
  end

  private

  def movie_check(movie_title, titles)
  	if titles.include?(movie_title)
  		"That is correct"
  	else
  		"That is incorrect"
  	end
  end

  def title_array(movies)
  	titles = []
  	movies.each do |movie|
  		titles << movie["original_title"]
  	end
  	titles
  end
end
