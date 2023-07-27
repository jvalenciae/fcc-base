# frozen_string_literal: true

module Middleware
  class CatchRackErrors
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    rescue JWT::DecodeError
      [
        401,
        { 'Content-Type' => 'application/json' },
        [
          {
            message: 'JWT token is invalid or expired',
            status: :unauthorized,
            type: 'unauthorized_error',
            errors: []
          }.to_json
        ]
      ]
    end
  end
end
