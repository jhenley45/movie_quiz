class CastsController < ApplicationController

	include RottenTomatoes


  def show
  end

  def index
  	search = params[:movie]
  	movie = RottenMovie.find(:title => search, :limit => 1)
  	link = movie.links.cast << "?apikey=netjf9tgnuwqjz5mkfkjcjj7"
  	response = HTTParty.get(link)
  	@body = JSON.parse(response.body)
  end

  def create
  end

  def new
  end
end
