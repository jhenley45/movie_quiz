class PeopleController < ApplicationController

  def index
  end

  def show
  end

  def create
  end

  def new
  	@person = Person.new
  	@movie = params[:movie]
  	binding.pry
  end
end
