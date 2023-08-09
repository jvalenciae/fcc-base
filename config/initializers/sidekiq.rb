# frozen_string_literal: true

require 'sidekiq/web'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1') }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1') }
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  Rack::Utils.secure_compare(Digest::SHA256.hexdigest(user),
                             Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_USER', 'user'))) &
    Rack::Utils.secure_compare(Digest::SHA256.hexdigest(password),
                               Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_PASSWORD', 'password')))
end
