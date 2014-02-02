class MoviesController < ApplicationController
  include RottenTomatoes


  def show
  end

  def index
  	# cast = params[:cast]
  	# a = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=netjf9tgnuwqjz5mkfkjcjj7&q="
  	# link = a << cast
  	# response = HTTParty.get(link)
  	# @body = JSON.parse(response.body)

  	# i = Imdb::Search.new("Bradley Cooper")
  	# @brad = i.movies

  # 	@search = Tmdb::Search.new
		# @search.resource('person') # determines type of resource
		# @search.query('samuel jackson') # the query to search against
		@brad = Tmdb::Person.credits(287)



	end


  def create
  end

  def new
  end
end
