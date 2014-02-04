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
		#movie = Movie.where(title: movie_title.split.map(&:capitalize).join(' '))
		movie = Movie.where("title ILIKE ?", "%#{movie_title}%") #returns ActiveRecord relation
		binding.pry
		if movie.empty? or !movie.first.populated?
			search = Tmdb::Search.new
			search.resource('movie')
			search.query(movie_title) # the query to search against
			movie_results = search.fetch
			if movie_results.empty?
		    raise MovieNotFound, "could not find movie #{movie_title}"
			else
				# create the movie
				movie = Movie.create!(title: movie_results.first["original_title"], tmdb_id: movie_results.first["id"]) #returns object
				binding.pry
				Person.create_cast_members(movie_results.first, movie)
				#set populated = true
				movie.populated = true
			end
		end
		movie
	end


	def self.create_movies_for_person(person)
		movies = Tmdb::Person.credits(person.tmdb_id)
		movies.first[1].each do |movie|
			#create a new movie for all of the movies the person is in
			movie = Movie.create!(title: movie["original_title"], tmdb_id: movie["id"])
			#create the corresponding cast_members join
			movie.cast_members.create!(person: person)
		end
	end

	# movie.has_cast_member?("joe")
	def has_cast_member?(cast_member_name)
		self.persons.any? { |person| person.name == cast_member_name }
	end

end
