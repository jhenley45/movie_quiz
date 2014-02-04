class Person < ActiveRecord::Base
	has_many :cast_members
	has_many :movies, through: :cast_members




	def self.create_cast_members(movie, movie_object)
		cast = Tmdb::Movie.casts(movie["id"]) #Get the cast
		binding.pry
		cast.each do |member|
			#create a new person for each cast member
			person = Person.create!(name: member["name"])
			#create the corresponding cast_members join
			person.cast_members.create!(movie: movie_object)
		end
	end

end
