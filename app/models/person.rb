class Person < ActiveRecord::Base
	has_many :cast_members
	has_many :movies, through: :cast_members


	def self.find_by_name(user_person)
		person = Person.lookup_person_by_name(user_person)
		# See if we have a person that matches
		if !person.empty?# Person is already in the DB
			if !person.first.populated? # person is in the DB but we have not populated their movies yet
				#populate movies db
				Movie.create_movies_for_person(person.first)
				#Get all of the movies for this person and set their populated column to true
				person.first.populated = true
				person.first.save
			else
				#We have already done the lookup for this person, just check to see if the answer is correct.
				return true
			end
			return true
		else
			#Person is not in the DB. Wrong answer, return false.
			false
		end
	end

	def self.validate_movie(person, movie)
		# Get person
		person = Person.lookup_person_by_name(person).first
		# See if the person is in the movie that the user put in.
		if person.movies.find_by title: movie
			return true
		else
			#person exists btu is NOT in the given movie. Error.
			false
		end
	end

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

	def self.lookup_person_by_name(name)
		Person.where("name ILIKE ?", "%#{name}%") #returns array
	end
end
