MovieQuiz::Application.routes.draw do




  # get "people/index"
  # get "people/show"
  # get "people/create"
  # get "people/new"
  get "rounds/index"
  get "rounds/show"
  get "rounds/new"
  get "rounds/create"
  #resources :movies
  # get "movies/index"
  # get "movies/show"
  # get "movies/new"
  # get "movies/create"
  devise_for :users
  #resources :casts
  get "casts/index"
  get "casts/show"
  get "casts/new"
  get "casts/create"

  resources :people
  resources :movies


  get "casts/incorrect_person" => 'casts#incorrect_person'
  get "movies/incorrect_movie" => 'movies#incorrect_movie'

  get "movie_quiz/show"
  get "movie_quiz/index"

  root to: 'users#index'
  end
