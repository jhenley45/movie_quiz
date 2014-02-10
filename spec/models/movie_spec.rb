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
end
