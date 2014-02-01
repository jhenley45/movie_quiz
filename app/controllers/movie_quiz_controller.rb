class MovieQuizController < ApplicationController
	include RottenTomatoes


	require 'net/http'


  def show
  end

  def index
  	#binding.pry
  	movie = RottenMovie.find(:title => "avatar", :limit => 1)
  	link = movie.links.cast << "?apikey=netjf9tgnuwqjz5mkfkjcjj7"
  	response = HTTParty.get(link)
  	@body = JSON.parse(response.body)
  end
end
