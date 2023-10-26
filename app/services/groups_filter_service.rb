# frozen_string_literal: true

class GroupsFilterService < ApplicationService
  attr_reader :params, :groups

  def initialize(groups, params)
    @groups = groups
    @params = params
  end

  def call
    apply_filters(groups)
  end

  private

  def apply_filters(groups)
    groups = groups.by_categories(params[:categories]) if params[:categories].present?
    groups = groups.by_branch_ids(params[:branch_ids]) if params[:branch_ids].present?
    groups = apply_by_q(groups, params[:q]) if params[:q].present?
    groups
  end

  def apply_by_q(groups, param_q)
    by_q = groups.search_by_q(param_q).with_pg_search_rank
    by_category = groups.search_by_category(param_q)

    (by_q + by_category).uniq
  end
end
