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

      resources :users, only: %i[index show create update destroy]

      resources :short_urls, only: %i[create] do
        collection do
          get :top100, to: 'short_urls#top100'
        end
      end
    end
  end

  get '/:shortened_url', to: 'api/v1/short_urls#redirect', as: :short_url_redirect
end
