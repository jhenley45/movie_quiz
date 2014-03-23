class MovieNotFound < StandardError
end

class Movie < ActiveRecord::Base
	has_many :cast_members
	has_many :people, through: :cast_members
	validates :title, presence: true
	validates :tmdb_id, presence: true

	# Finds and returns movie object from db based on user-sibmitted title. If not, returns false
	# Checks to see if the movie's cast has been populated
	def self.find_movie_in_db(movie_title)
		movie = Movie.where("title ILIKE ?", "%#{movie_title}%").first
		if !movie.present?
			return false
		else
			movie.populate_cast_members?
			return movie
		end
	end

	# Creates a new movie object in the DB.
	# Also calls Person method to create AR relationship for all cast members of this movie
	# Returns false if movie not found in TMDB search
	def self.create_new_tmdb_movie(movie_title)
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

	# Search tmdb for a movie and return results
	def self.tmdb_movie_lookup(movie_title)
		search = Tmdb::Search.new
		search.resource('movie')
		search.query(movie_title) # the query to search against
		movie_results = search.fetch
	end

	# Check to see that the movie belongs to the person
	def validate_person_in_movie(person)
		person = Person.lookup_person_in_db(person)
		if self.people.find_by name: person.name
			true
		else
			#round is over
			false
		end
	end

	# If movie is unpopulated, populates it
	def populate_cast_members?
		if !self.populated?
			Person.create_cast_members(self)
			self.populated = true
			self.save
		end
	end

	# Creates a new AR relationship for all movies of a given person
	# Depending on whether or not each movie exists in DB already, may create new movies
	def self.create_movies_for_person(person)
		#Get all of the movies for this person
		movies = Tmdb::Person.credits(person.tmdb_id)
		movies.first[1].each do |movie|
			if !Movie.find_by(tmdb_id: movie["id"])
				movie = Movie.create!(title: movie["original_title"], tmdb_id: movie["id"])
				movie.cast_members.create!(person: person)
			elsif !Movie.find_by(tmdb_id: movie["id"]).cast_members.find_by_person_id(person["id"])
				movie = Movie.find_by_tmdb_id(movie["id"])
				movie.cast_members.create!(person: person)
			end
		end
	end

end
