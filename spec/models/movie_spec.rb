require 'spec_helper'

describe Movie do

	it 'is invalid without a title' do
		expect(Movie.create(tmdb_id: 54345, populated: false)).to_not be_valid
	end
	it 'is invalid without a tmdb_id' do
		expect(Movie.create(title: 'The Departed', populated: false)).to_not be_valid
	end


  describe 'associations' do
  	it {should have_many :cast_members}
  	it {should have_many :people}
  end
end
