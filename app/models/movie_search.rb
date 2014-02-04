class MovieSearch < ActiveRecord::Base
	has_many :cast_members
	has_many :people, through: :cast_members
end
