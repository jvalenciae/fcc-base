# frozen_string_literal: true

module Api
  module V1
    class SurveyResponsesController < ApiController
      def index
        @survey_responses = SurveyResponse.accessible_by(current_ability)
                                          .by_survey_ids(params[:survey_ids]).includes([:branch])
        @survey_responses = Filter::SurveyResponsesFilterService.call(@survey_responses, params)
        @survey_responses, meta = paginate_resources(@survey_responses)
        render_response(data: @survey_responses, serializer: SurveyResponseSerializer, meta: meta)
      end
    end
  end
end
