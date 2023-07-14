# frozen_string_literal: true

Rails.application.routes.draw do
  Healthcheck.routes(self)
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      resources :countries, only: %i[index]

      resources :cities, only: %i[index]

      resources :organizations, only: %i[index]

      resources :branches, only: %i[index]
    end
  end
end
