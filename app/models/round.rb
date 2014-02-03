class Round < ActiveRecord::Base

	belongs_to :user


	def update_score
		@score += 5
	end

end
