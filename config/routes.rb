# frozen_string_literal: true

Rails.application.routes.draw do
  Healthcheck.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  devise_for :users, path: '',
                     controllers: {
                       passwords: 'api/v1/auth/passwords',
                       sessions: 'api/v1/auth/sessions'
                     }, defaults: { format: :json }

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      namespace :auth do
        as :user do
          post '/sign_in', to: 'sessions#create'
          delete '/sign_out', to: 'sessions#destroy'
        end

        resources :passwords, only: %i[create update]
      end

      resources :countries, only: %i[index]

      resources :cities, only: %i[index]

      resources :organizations, only: %i[index]

      resources :branches, only: %i[index]

      resources :users, only: %i[index show create update destroy]
    end
  end
end
