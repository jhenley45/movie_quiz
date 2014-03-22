class MovieNotFound < StandardError
end

class Movie < ActiveRecord::Base
	has_many :cast_members
	has_many :people, through: :cast_members
	validates :title, presence: true
	validates :tmdb_id, presence: true


	def self.check_movie_name(title)
		movie = Movie.lookup_by_title(title)
		if movie.present? #movie is in the DB
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
		movie = Movie.lookup_by_title(movie_title)
		if !movie.present?
			return false
		else
			movie.populate_cast_members?
			return movie
		end
	end

	def populate_cast_members?
		if !self.populated?
			Person.create_cast_members(self)
			self.populated = true
			self.save
		end
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

	# Check to see if the person is in the movie
	def self.validate_person(title, person)
		movie = Movie.lookup_by_title(title)
		person = Person.lookup_person_by_name(person).first
		if movie.people.find_by name: person.name
			true
		else
			#round is over
			false
		end
	end

	# Get movie object out of DB
	def self.lookup_by_title(title)
		Movie.where("title ILIKE ?", "%#{title}%").first
	end
end
