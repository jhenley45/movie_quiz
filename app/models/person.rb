class Person < ActiveRecord::Base
	has_many :cast_members
	has_many :movies, through: :cast_members


	def self.find_by_name(user_person)
		person = Person.where("name ILIKE ?", "%#{user_person}%") #returns array
		binding.pry
		# See if we have a person that matches
		if !person.empty?# Person is already in the DB

			if !person.first.populated? # person is in the DB but we have not populated their movies yet
				#populate movies db
				Movie.create_movies_for_person(person.first)
				#Get all of the movies for this person and set their populated column to true
				binding.pry
				person.first.populated = true
				person.first.save
			else
				#We have already done the lookup for this person, just check to see if the answer is correct.
			end

			return true
		else
			# Round is over. If the person is not found, then they were not in the movie that brought the user here.
			# redirect_to root_path
		end

	end

	def self.validate_movie(person, movie)
		# Get person
		person = Person.where("name ILIKE ?", "%#{person}%").first
		# See if the person is in the movie that the user put in.
		if person.movies.find_by title: movie
			return true
		end
	end

	def self.create_cast_members(movie, movie_object)
		cast = Tmdb::Movie.casts(movie["id"]) #Get the cast
		binding.pry
		cast.each do |member|
			#check if the person is already in DB by tmdb_id
			if !Person.find_by(tmdb_id: member["id"])
				#create a new person for each cast member
				person = Person.create!(name: member["name"], tmdb_id: member["id"])
				#create the corresponding cast_members join
				person.cast_members.create!(movie: movie_object)
			end
		end
	end

end
