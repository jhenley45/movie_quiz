class Cast < ActiveRecord::Base

	def find_person_movies(person)
		@search = Tmdb::Search.new
		@search.resource('person') # determines type of resource
		@search.query(person) # the query to search against
		@person = @search.fetch #make the search
		id = @person.first["id"]
		Tmdb::Person.credits(id)
	end

	def self.find_cast(movie)
		search = Tmdb::Movie.find(movie) #find the movie
		if search.empty?
			#do something
		else
  		id = search.first.id #Get the id
  		Tmdb::Movie.casts(id) #Get the cast
  	end
	end


end
