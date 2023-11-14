# frozen_string_literal: true

module Filter
  class BranchesFilterService < ApplicationService
    attr_reader :params, :branches

    def initialize(branches, params)
      @branches = branches
      @params = params
    end

    def call
      apply_filters(branches)
    end

    private

    # rubocop:disable Metrics/AbcSize
    def apply_filters(branches)
      branches = branches.by_organization_ids(params[:organization_ids]) if params[:organization_ids].present?
      branches = branches.by_departments(params[:departments], params[:countries]) if params[:departments].present?
      branches = branches.by_countries(params[:countries]) if params[:countries].present?
      branches = branches.search_by_q(params[:q]).with_pg_search_rank if params[:q].present?
      branches
    end
    # rubocop:enable Metrics/AbcSize
  end
end
