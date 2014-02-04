MovieQuiz::Application.routes.draw do




  get "rounds/index"
  get "rounds/show"
  get "rounds/new"
  get "rounds/create"
  resources :movies
  devise_for :users
  resources :casts



  get "casts/incorrect_movie" => 'casts#incorrect_movie'
  get "movies/incorrect_person" => 'movies#incorrect_person'

  get "movie_quiz/show"
  get "movie_quiz/index"

  root to: 'users#index'
  end
