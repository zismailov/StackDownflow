Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, only: [:new, :create, :edit, :update, :destroy] do
      post "mark_best", on: :member
    end
  end

  root "questions#index"
end
