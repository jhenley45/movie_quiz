class MoviesController < ApplicationController


  def show
  end

  def index
	end


  def create
    #This will trigger on every turn besides the first
    if params[:movie]["person"].present?
      title = params[:movie]["title"]
      person = params[:movie]["person"]
      #check to see if user input is already in session
      if session[:answers].include?(title)
        session[:answers] = nil
        flash['alert'] = "Sorry, but you already entered #{title}. Final score: #{current_user.rounds.last.score}"
        # end round
        redirect_to root_path
      else
        #add title to session
        session[:answers] << title
        #movie = Movie.where("title ILIKE ?", "%#{title}%")
        if Movie.find_by_movie_name(title) == true
          if Movie.validate_person(title, person) == true
            update_score
            update_level_up
            movie = Movie.find_or_create_movie(title)
            #Movie could either be ActiveRecord relation (if it existed) or movie object (if it's a new movie).
            if movie.class.name == "Movie"
              redirect_to new_person_path(:movie => movie["title"])
              flash['notice'] = "Correct! #{person} was in #{title}."
            else
              redirect_to new_person_path(:movie => movie.first["title"])
              flash['notice'] = "Correct! #{person} was in #{title}."
            end
          else
            session[:answers] = nil
            # this person is not in the movie
            flash['alert'] = "Sorry, but #{person} is not in #{title}. Final score: #{current_user.rounds.last.score}"
            # end round
            redirect_to root_path
          end
        else
          session[:answers] = nil
          flash['alert'] = "Sorry, but we could not find any movies called '#{title}'. Make sure you didn't make any spelling errors. Final score: #{current_user.rounds.last.score}"
          # end round
          redirect_to root_path
        end
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
      movie = Movie.find_or_create_movie(params[:movie]["title"])
      #redirect to person path
      #Movie could either be ActiveRecord relation (if it existed) or movie object (if it's a new movie).
      if movie.class.name == "Movie"
        redirect_to new_person_path(:movie => movie["title"])
      else
        redirect_to new_person_path(:movie => movie.first["title"])
      end
    end
  end

  def new
    @movie = Movie.new
    if current_user.rounds.last.level < 5
      @initial_time = 25 - (current_user.rounds.last.level * 5)
    else
      @initial_time = 5
    end
    @person = params[:person]
  end

  private

end
