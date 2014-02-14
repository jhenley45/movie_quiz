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

  	before :each do
  		@departed = Movie.tmdb_movie_lookup('the departed')
  	end
  	it 'should return an array when called' do
  		expect(Movie.tmdb_movie_lookup('test')).to be_an_instance_of(Array)
  	end
  	it 'should return the title of a movie within the array' do
  		expect(@departed.first["original_title"]).to eq 'The Departed'
  	end
  end

  describe '.find_movie_in_db' do
  	before :each do
  		@departed = Movie.create!(title: 'The Departed', tmdb_id: 4433, populated: true)
  	end

  	it 'should return the movie object when it is found' do
  		expect(Movie.find_movie_in_db('the departed')).to eq @departed
  	end
  	it 'should return false when no movie is found' do
  		expect(Movie.find_movie_in_db('dfsdas')).to be false
  	end
  end

  # describe '.create_new_movie' do
  # 	it 'should create a new movie' do
  # 		expect(Movie.create_new_movie('swingers')).to be_an_instance_of(Movie)
  # 	end

  end

end
