class Person < ActiveRecord::Base
	has_many :cast_members
	has_many :movies, through: :cast_members


	def self.find_by_name(user_person)
		person = Person.where("name ILIKE ?", "%#{user_person}%") #returns array
		binding.pry
		# See if we have a person that matches
		if !person.empty? #correct answer!

			if !person.first.populated?
				#populate movies db
				Movie.create_movies_for_person(person.first)
				#Get all of the movies for this person and set their populated column to true
				person.populated = true
				#populate movies db


			elsif person.first.populated?
				#We have already done the lookup for this person, just check to see if the answer is correct.
			end


		else
			# Round is over. If the person is not found, then they were not in the movie that brought the user here.
		end

	end

	def self.create_cast_members(movie, movie_object)
		cast = Tmdb::Movie.casts(movie["id"]) #Get the cast
		binding.pry
		cast.each do |member|
			#create a new person for each cast member
			person = Person.create!(name: member["name"], tmdb_id: member["id"])
			#create the corresponding cast_members join
			person.cast_members.create!(movie: movie_object)
		end
	end

end
