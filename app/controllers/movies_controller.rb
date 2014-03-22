class MoviesController < ApplicationController
  before_action :authenticate_user!

  def index
	end

  def create
    #This will trigger on every turn besides the first
    if params[:movie]["person"].present?
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
          #Check to see if the movie is in the DB
          if Movie.check_movie_in_db(title) == true
            #Check to see that the movie belongs to the person
            if Movie.validate_person_in_movie(title, person) == true
              #correct answer
              update_score
              update_level_up
              # Get the movie to pass to person#new in correct format
              movie = Movie.find_movie_in_db(title)
              redirect_to new_person_path(:movie => movie["title"])
              flash['notice'] = "Correct! #{person} was in #{title}."
            else
              session[:answers] = nil
              # this person is not in the movie
              flash['alert'] = "Sorry, but #{person} is not in #{title}. Final score: #{current_user.rounds.last.score}"
              # end round
              redirect_to root_path
            end
          else
            session[:answers] = nil
            flash['alert'] = "Sorry, but we could not find any movies called '#{title}' that #{person} was in. Make sure you didn't make any spelling errors. Final score: #{current_user.rounds.last.score}"
            # end round
            redirect_to root_path
          end
        end
      else
        flash['alert'] = "Cheating is bad for your health."
        redirect_to root_path
      end
    # If the string is empty
    elsif params[:movie]["title"].empty?
      flash['alert'] = "You must enter a correct title to start the game, genius. Try again."
      # end round
      redirect_to root_path
    else
      #add the movie to the session
      session[:answers] = []
      session[:answers] << params[:movie]["title"]
      #first time. Returns the movie
      movie = Movie.find_movie_in_db(params[:movie]["title"])
      if movie == false
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
