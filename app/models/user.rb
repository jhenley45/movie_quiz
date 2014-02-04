class User < ActiveRecord::Base

	has_many :rounds
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def find_high_scores
  	User.all.rounds
  end
end
