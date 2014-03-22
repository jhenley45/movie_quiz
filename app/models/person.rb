class Person < ActiveRecord::Base
	has_many :cast_members
	has_many :movies, through: :cast_members


	def self.lookup_person_in_db(user_person)
		person = Person.where("name ILIKE ?", "%#{user_person}%").first
		# See if we have a person that matches
		if !person.present?# Person is not in DB
			return false
		else
			person.person_populate_cast_members?
			return person
		end
	end

	def validate_movie(movie)
		# See if the person is in the movie that the user put in.
		if self.movies.find_by title: movie
			return true
		else
			#person exists but is NOT in the given movie. Error.
			false
		end
	end

	def person_populate_cast_members?
		if !self.populated?
			#populate movies db
			Movie.create_movies_for_person(self)
			#Get all of the movies for this person and set their populated column to true
			self.populated = true
			self.save
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

end
