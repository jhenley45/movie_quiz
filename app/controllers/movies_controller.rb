class MoviesController < ApplicationController


	def incorrect_movie
    @person = params[:person]
    @movie_name = params[:movie_name]
    @all_movies = Movie.find_movies(@person)
	end

  def show
  end

  def index
  	if params[:person].present?
  		person = params[:person]
  		#find all the movies for this person.
  		@movies = Movie.find_movies(person)
      if @movies.nil?
        redirect_to root_path
      else
  		#clean results (returns array)
  		@movie = @movies.first[1]

  		#Get the correct name of the user input
  		@correct_name = Tmdb::Person.find(person).first.name


  		#create array of titles
  		@titles = title_array(@movie)
  		#get the movie title from the params
  		@movie_name = params[:movie_name]
  		#determine if the user input matches the titles we have
  		@answer = movie_check(@movie_name, @titles, @correct_name)
    end
  	end
	end


  def create

    if params[:person].present?
      if params[:person].movies.any? == params[:movie]
        find_or_create_movie(params[:movie])
      else
        #incorrect answer
      end
    end

    find_or_create_movie(params[:movie])
    redirect_to new_person_path


  end

  def new
  end

  private

  def movie_check(movie_title, titles, person)
  	if titles.include?(movie_title)
  		#update the score
  		update_score
  		#update level_up
  		update_level_up
  		#return message to print
  		"Correct, #{person} was in #{movie_title}."
  	else
      # Person not in the movie, redirect to incorrect_person
  		redirect_to :controller => :casts, :action => :incorrect_person, :person => person, :movie_title => movie_title
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
