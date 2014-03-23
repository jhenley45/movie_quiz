class MoviesController < ApplicationController
  before_action :authenticate_user!
  before_filter :get_user

  def index
	end

  def create
    if params[:movie]["person"].present? # This will trigger on every turn besides the first
      title = params[:movie]["title"]
      person = params[:movie]["person"]
      #Check to see if the user is trying to replay the round
      if !session[:answers].nil?
      #check to see if user input is already in session
        if session[:answers].include?(title)
          # We got a cheater on our hands, over.
          session[:answers] = nil
          flash['alert'] = "Sorry, but you already entered #{title}. Final score: #{current_user.rounds.last.score}"
          redirect_to root_path
        else
          # Unique submission, add title to session
          session[:answers] << title
          movie = Movie.find_movie_in_db(title)
          if !movie # not a valid movie-person combo
            session[:answers] = nil
            flash['alert'] = "Sorry, but we could not find any movies called '#{title}' that #{person} was in. Make sure you didn't make any spelling errors. Final score: #{current_user.rounds.last.score}"
            redirect_to root_path
          elsif movie.validate_person_in_movie(person) == true
            @user.update_score
            @user.update_level_up
            redirect_to new_person_path(:movie => movie["title"])
            flash['notice'] = "Correct! #{person} was in #{title}."
          else # this person is not in the movie
            session[:answers] = nil
            flash['alert'] = "Sorry, but #{person} is not in #{title}. Final score: #{current_user.rounds.last.score}"
            redirect_to root_path
          end
        end
      else
        flash['alert'] = "Cheating is bad for your health."
        redirect_to root_path
      end
    elsif params[:movie]["title"].empty? #empty submission
      flash['alert'] = "You must enter a correct title to start the game, genius. Try again."
      redirect_to root_path
    else # Beginning of a new round
      session[:answers] = [] # initialize session
      session[:answers] << params[:movie]["title"]
      movie = Movie.find_movie_in_db(params[:movie]["title"])
      if movie == false # new movie, need to fetch from TMDB and create it
        movie = Movie.create_new_tmdb_movie(params[:movie]["title"])
        if movie == false
          flash['alert'] = "We couldn't find that movie. Please make sure you did not make any spelling errors."
          # end round
          redirect_to root_path and return
        end
      end
      # All is well. Redirect to new person with sanitated movie title
      redirect_to new_person_path(:movie => movie["title"])
    end
  end

  def new
    @movie = Movie.new
    if current_user.rounds.last.level < 4
      @initial_time = 22 - (current_user.rounds.last.level * 2)
    else
      @initial_time = 15
    end
    @person = params[:person]
  end

end
