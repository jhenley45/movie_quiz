class MovieNotFound < StandardError
end

class Movie < ActiveRecord::Base
	has_many :cast_members
	has_many :people, through: :cast_members


	def self.find_movies(person)
		@search = Tmdb::Search.new #initialize search
		@search.resource('person') # determines type of resource
		@search.query(person) # the query to search against
		@person = @search.fetch #make the search
		if @person.empty? == true
			return
		else
			id = @person.first["id"]
			Tmdb::Person.credits(id)
		end
	end

	# return a  movie OR raise a MovieNotFound exception
	def self.find_or_create_movie(movie_title)
		# look in the DB  for the movie with this title
		movie = Movie.find_by_title(movie_title)
		if movie == nil
			search = Tmdb::Search.new
			search.resource('movie')
			search.query(movie_title) # the query to search against
			movie_results = @search.fetch
			if movie_results.empty?
		    raise MovieNotFound, "could not find movie #{movie_title}"
			else
				# create the movie
				movie = Movie.create!(title: movie_result.first.original_title, tmdb_id: movie_results.first.id)
				Person.create_cast_members(movie)
			end
		end
		movie
	end

	# movie.has_cast_member?("joe")
	def has_cast_member?(cast_member_name)
		self.persons.any? { |person| person.name == cast_member_name }
	end

end
