TranslationMvp::Application.routes.draw do
  root to: 'public#index'

  resources :users do
    member do
      get :authorize
    end
  end

  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :sessions, :except => [ :edit, :update ]
end