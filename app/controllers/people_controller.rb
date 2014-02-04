class PeopleController < ApplicationController

  def index
  end

  def show
  end

  def create
  	person = params[:person]["name"]
  	Person.find_by_name(person)
  end

  def new
  	@person = Person.new
  	@movie = params[:movie]
  	binding.pry
  end
end
