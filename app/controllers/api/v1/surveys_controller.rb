# frozen_string_literal: true

module Api
  module V1
    class SurveysController < ApiController
      before_action :set_survey, only: %i[show update]

      def index
        @surveys = Survey.accessible_by(current_ability)
        @surveys, meta = paginate_resources(@surveys)
        render_response(data: @surveys, serializer: SurveySerializer, meta: meta)
      end

      def show
        authorize!(:read, @survey, message: I18n.t('unauthorized.read.survey'))
        render_response(data: @survey, serializer: SurveySerializer)
      end

      def create
        @survey = Survey.new(survey_params)
        authorize!(:create, @survey, message: I18n.t('unauthorized.create.survey'))
        render_response(data: @survey, serializer: SurveySerializer) if @survey.save!
      end

      def update
        @survey.assign_attributes(survey_params)
        authorize!(:update, @survey, message: I18n.t('unauthorized.update.survey'))
        render_response(data: @survey, serializer: SurveySerializer) if @survey.save!
      end

      private

      def set_survey
        @survey = Survey.find(params[:id])
      end

      def survey_params
        params.require(:survey).permit(
          :name, :description, :form_id, :organization_id
        )
      end
    end
  end
end
