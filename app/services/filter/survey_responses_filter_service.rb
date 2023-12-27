# frozen_string_literal: true

module Filter
  class SurveyResponsesFilterService < ApplicationService
    attr_reader :params, :survey_responses

    def initialize(survey_responses, params)
      @survey_responses = survey_responses
      @params = params
    end

    def call
      apply_filters(survey_responses)
    end

    private

    # rubocop:disable Metrics/AbcSize
    def apply_filters(survey_responses)
      survey_responses = survey_responses.by_survey_key(params[:key])
      survey_responses = survey_responses.by_branch_ids(params[:branch_ids])
      survey_responses = survey_responses.by_group_ids(params[:group_ids])
      survey_responses = survey_responses.by_categories(params[:categories])
      survey_responses = survey_responses.by_gender(params[:gender])
      survey_responses = survey_responses.by_kind_of_measurement(params[:kind_of_measurement])
      survey_responses = survey_responses.by_years(params[:years]) if params[:years].present?
      survey_responses
    end
    # rubocop:enable Metrics/AbcSize
  end
end
