Rails.application.routes.draw do
  devise_for :users

  resources :questions, only: %i[index new create show] do
    resources :answers, only: [:create]
  end

  root "questions#index"
end
