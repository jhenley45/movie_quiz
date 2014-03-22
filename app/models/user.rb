class User < ActiveRecord::Base

	has_many :rounds
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def find_high_scores
  	User.all.rounds
  end

  def update_score
  	#get the current round for the user
		@round = self.rounds.last
		#increment the score
		@round.score += (1000 * self.rounds.last.level)
		#save the new score
		@round.save
  end

  def update_level_up
  	@round = self.rounds.last
  	@round.level_up += 1
  	if @round.level_up == 5
  		@round.level += 1
  		@round.level_up = 0
  	end
  	@round.save
  end

end
