Rails.application.routes.draw do
  devise_for :users
  resources :books
  resources :users, only: [:show, :edit, :update, :index]
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
