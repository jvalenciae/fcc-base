# frozen_string_literal: true

class ApiController < ApplicationController
  include ApiResponses
  include ExceptionHandler
  include PaginationHandler

  # before_action :authenticate_user!
  before_action :set_locale

  def set_locale
    I18n.locale = if request.headers['Accept-Language']
                    request.headers['Accept-Language'][0..1]
                  else
                    I18n.default_locale
                  end
  end
end
