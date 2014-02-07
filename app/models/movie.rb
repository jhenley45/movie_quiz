class MovieNotFound < StandardError
end

class Movie < ActiveRecord::Base
	has_many :cast_members
	has_many :people, through: :cast_members


	def self.check_movie_name(title)
		movie = Movie.where("title ILIKE ?", "%#{title}%")
		if !movie.empty? #movie is in the DB
			return true
		else
			#Round is over. If we can't find the movie, then the person that brought us here was not in it.
			false
		end
	end

	# Searched tmdb for a movie
	def self.tmdb_movie_lookup(movie_title)
		search = Tmdb::Search.new
		search.resource('movie')
		search.query(movie_title) # the query to search against
		movie_results = search.fetch
	end

	def self.find_movie_in_db(movie_title)
		movie = Movie.where("title ILIKE ?", "%#{movie_title}%")
		if movie.empty?
			return false
		elsif !movie.first.populated?
			Person.create_cast_members(movie.first)
			#Actors now in people table, set populated = true
			movie.first.populated = true
			movie.first.save
		end
		movie.first #return movie object
	end

	def self.create_new_movie(movie_title)
		movie_results = Movie.tmdb_movie_lookup(movie_title)
		if movie_results.empty?
			return false
		end
		movie = Movie.create!(title: movie_results.first["original_title"], tmdb_id: movie_results.first["id"])
		Person.create_cast_members(movie)
		#Actors now in people table, set populated = true
		movie.populated = true
		movie.save
		movie
	end


	def self.create_movies_for_person(person)
		#Get all of the movies for this person
		movies = Tmdb::Person.credits(person.tmdb_id)
		movies.first[1].each do |movie|
			#check if the movie exists in the DB
			if !Movie.find_by(tmdb_id: movie["id"])
				#create a new movie for all of the movies the person is in
				movie = Movie.create!(title: movie["original_title"], tmdb_id: movie["id"])
				#create the corresponding cast_members join
				movie.cast_members.create!(person: person)
			elsif !Movie.find_by(tmdb_id: movie["id"]).cast_members.find_by_person_id(person["id"])
				movie = Movie.find_by_tmdb_id(movie["id"])
				movie.cast_members.create!(person: person)
			end
		end
	end

	# movie.has_cast_member?("joe")
	def self.validate_person(title, person)
		movie = Movie.where("title ILIKE ?", "%#{title}%").first
		person = Person.where("name ILIKE ?", "%#{person}%").first
		if movie.people.find_by name: person.name
			true
		else
			#round is over
			false
		end
	end
	# return a  movie OR raise a MovieNotFound exception
	# def self.find_or_create_movie(movie_title)
	# 	# look in the DB  for the movie with this title
	# 	movie = Movie.where("title ILIKE ?", "%#{movie_title}%") #returns ActiveRecord relation
	# 	# need to populate all of the actors for the movie if it is not in the DB, or if we have not done so yet.
	# 	if movie.empty? or !movie.first.populated?
	# 		# Get the movie from the db
	# 		movie_results = Movie.tmdb_movie_lookup(movie_title)
	# 		if movie_results.empty?
	# 	    return false
	# 		else
	# 			# create the movie if it does not exist
	# 			if movie.empty?
	# 				movie = Movie.create!(title: movie_results.first["original_title"], tmdb_id: movie_results.first["id"]) #returns object
	# 			elsif !movie.first.populated? # movie already exists but not populated, assign movie object to movie variable
	# 				movie = movie.first
	# 			end
	# 			Person.create_cast_members(movie_results.first, movie)
	# 			#Actors now in people table, set populated = true
	# 			movie.populated = true
	# 			movie.save
	# 		end
	# 	end
	# 	#return the movie
	# 	movie
	# end

end
