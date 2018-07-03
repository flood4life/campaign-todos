Rails.application.routes.draw do
  root "welcome#index"

  devise_for :users
  
  resources :campaigns, only: %i[index new create show] do
    resources :todo_lists, only: %i[new create show], shallow: true do
      resources :comments, only: %i[new create], shallow: true
    end
    resources :comments, only: %i[new create], shallow: true
  end
  resources :users, only: %i[show edit update]
end
