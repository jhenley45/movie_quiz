class Person < ActiveRecord::Base
	has_many :cast_members
	has_many :movies, through: :cast_members

	# Finds and returns person object from DB. Checks to see if person needs to be populated.
	# Returns false if person is not found (wrong answer)
	def self.lookup_person_in_db(user_person)
		person = Person.where("name ILIKE ?", "%#{user_person}%").first
		if !person.present?
			return false
		else
			person.person_populate_cast_members?
			return person
		end
	end

	# Validates that the person was in the movie
	def validate_movie_for_person(movie)
		if self.movies.find_by title: movie
			return true
		else
			#round is over
			false
		end
	end

	#checks to see if we need to populate all of the movies for this person
	def person_populate_cast_members?
		if !self.populated?
			#populate movies db
			Movie.create_movies_for_person(self)
			#Get all of the movies for this person and set their populated column to true
			self.populated = true
			self.save
		end
	end

	# populates all of the people for a given movie.
	# May create new people if they do not exist yet in the DB
	def self.create_cast_members(movie)
		cast = Tmdb::Movie.casts(movie.tmdb_id) #Get the cast
		cast.each do |member|
			#check if the person is already in DB by tmdb_id
			if !Person.find_by(tmdb_id: member["id"])
				#create a new person for each cast member
				person = Person.create!(name: member["name"], tmdb_id: member["id"])
				#create the corresponding cast_members join
				person.cast_members.create!(movie: movie)
			#If the person is there but the relationship is not, we need to create the relationship
			elsif !Person.find_by(tmdb_id: member["id"]).cast_members.find_by_movie_id(movie["id"])
				#find the person
				person = Person.find_by_tmdb_id(member["id"])
				#create the relationship
				person.cast_members.create!(movie: movie)
			end
		end
	end

end
