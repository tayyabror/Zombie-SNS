Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    resources :survivors, except: [:edit, :new] do
      member do
        post 'reported_infected_survivor'
      end
    end
    resources :items, except: [:edit, :new] do
      collection do
        post 'trade'
      end
    end

    namespace :reports do
      get 'generate_report'
    end
  end
end
