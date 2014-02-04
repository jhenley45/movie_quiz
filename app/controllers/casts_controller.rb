class CastsController < ApplicationController



  def incorrect_movie
  		binding.pry
  	  @correct_name = params[:correct_name]
	  	@search = Tmdb::Search.new
	  	@search.resource('person') # determines type of resource
	  	@search.query(@correct_name) # the query to search against
	  	@person = @search.fetch #make the search
	  	id = @person.first["id"]
	  	@wrong_person_movies = Tmdb::Person.credits(id)

  end

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
  		#update the score
  		update_score
  		#update level_up
  		update_level_up
  		#return message to print
  		"Correct, #{name} WAS in #{movie_name}."

  	else
  		redirect_to :controller => :casts, :action => :incorrect_movie, :correct_name => name
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
