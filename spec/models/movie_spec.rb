require 'spec_helper'

describe Movie do

	describe 'validations' do
		it { should validate_presence_of(:title) }
		it { should validate_presence_of(:tmdb_id) }
		it { should validate_presence_of(:populated) }
	end

  describe 'associations' do
  	it {should have_many :cast_members}
  	it {should have_many :people}
  end

  describe '.check_movie_name' do
  	before :each do
  		@departed = Movie.create!(title: 'The Departed', tmdb_id: 4433, populated: true)
  	end

  	it 'Should return false if no movie is found' do
  		expect(Movie.check_movie_name('dfadsgsfg')).to eq false
  	end
  	it 'Should return true for a valid movie' do
  		expect(Movie.check_movie_name('The Departed')).to eq true
  	end
  end

  describe '.tmdb_movie_lookup' do
  	it 'should return an array when called' do
  		expect(Movie.tmdb_movie_lookup('test')).to be_an_instance_of(Array)
  	end

  end

end
