class Movie < ActiveRecord::Base


	def self.find_movies(person)
		@search = Tmdb::Search.new #initialize search
		@search.resource('person') # determines type of resource
		@search.query(person) # the query to search against
		@person = @search.fetch #make the search
		id = @person.first["id"]
		Tmdb::Person.credits(id)
	end
end
