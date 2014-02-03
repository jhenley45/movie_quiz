class Movie < ActiveRecord::Base

	def self.find_movie(cast)
		@search = Tmdb::Search.new #initialize search
		@search.resource('person') # determines type of resource
		@search.query(cast) # the query to search against
		@person = @search.fetch #make the search
		id = @person.first["id"]
		Tmdb::Person.credits(id)
	end
end
