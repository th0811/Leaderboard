Rails.application.routes.draw do
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :create] do
    get '/autocomplete_name/:name', on: :collection, action: :autocomplete_name
    collection do
      get :search
    end
  end
  
  get 'input', to: 'games#new'
  resources :games, only: [:index, :show, :create, :edit, :update] do
    resources :comments, only: [:create, :destroy]
  end
  
end
