# frozen_string_literal: true

module Filter
  class UsersFilterService < ApplicationService
    attr_reader :params, :users

    def initialize(users, params)
      @users = users
      @params = params
    end

    def call
      apply_filters(users)
    end

    private

    def apply_filters(users)
      users = users.by_role(params[:role])
      users = users.by_categories(params[:categories])
      users = users.by_departments(params[:departments], params[:countries])
      users = users.by_countries(params[:countries])
      users = users.search_by_q(params[:q]).with_pg_search_rank if params[:q].present?
      users
    end
  end
end
