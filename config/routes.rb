# frozen_string_literal: true

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
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

      resources :departments, only: %i[index]

      resources :cities, only: %i[index]

      resources :organizations, only: %i[index show create update]

      resources :allies, only: %i[index show create update]

      resources :branches, only: %i[index show create update]

      resources :users, only: %i[index show create update destroy] do
        collection do
          get 'members', to: 'users#members'
          get 'roles', to: 'users#roles'
        end
      end

      resources :groups, only: %i[index show create update destroy] do
        collection do
          get 'categories', to: 'groups#categories'
          get 'export', to: 'groups#export'
        end
      end

      resources :students, only: %i[index show create update destroy] do
        collection do
          get 'export', to: 'students#export'
          post 'import', to: 'students#import'
        end
      end

      resources :attendances, only: %i[index show create update destroy]

      resources :reports, only: %i[index show create update destroy]

      resources :surveys, only: %i[index show create update] do
        collection do
          get 'default', to: 'surveys#default'
          get 'ad_hoc', to: 'surveys#ad_hoc'
        end
      end
      namespace :surveys do
        resource :webhook, only: :create
      end

      resources :survey_responses, only: %i[index]
    end
  end
end
