Rails.application.routes.draw do

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  devise_for :users
  resources :books
  resources :users, only: [:show, :edit, :update, :index]
end
