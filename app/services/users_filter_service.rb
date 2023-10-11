# frozen_string_literal: true

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

  # rubocop:disable Metrics/AbcSize
  def apply_filters(users)
    users = users.by_role(params[:role]) if params[:role].present?
    users = users.by_branch_ids(params[:branch_ids]) if params[:branch_ids].present?
    users = users.by_categories(params[:categories]) if params[:categories].present?
    users = users.by_departments(params[:departments]) if params[:departments].present?
    users = users.search_by_q(params[:q]).with_pg_search_rank if params[:q].present?
    users
  end
  # rubocop:enable Metrics/AbcSize
end