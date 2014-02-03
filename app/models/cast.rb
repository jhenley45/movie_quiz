class Cast < ActiveRecord::Base

	def self.find_cast(movie)
		search = Tmdb::Movie.find(movie) #find the movie
  	id = search.first.id #Get the id
  	Tmdb::Movie.casts(id) #Get the cast
	end
end
