# frozen_string_literal: true

class ApiController < ApplicationController
  include ApiResponses
  include ExceptionHandler
  include PaginationHandler

  before_action :authenticate_user!
end
