# frozen_string_literal: true

module Api
  module V1
    class ReportsController < ApiController
      before_action :set_report, only: %i[show update destroy]

      def index
        @reports = Report.accessible_by(current_ability)
        @reports, meta = paginate_resources(@reports)
        render_response(data: @reports, serializer: ReportSerializer, meta: meta)
      end

      def show
        authorize!(:read, @report, message: I18n.t('unauthorized.read.report'))
        render_response(data: @report, serializer: ReportSerializer)
      end

      def create
        @report = Report.new(report_params)
        authorize!(:create, @report, message: I18n.t('unauthorized.create.report'))
        render_response(data: @report, serializer: ReportSerializer) if @report.save!
      end

      def update
        @report.assign_attributes(report_params)
        authorize!(:update, @report, message: I18n.t('unauthorized.update.report'))
        render_response(data: @report, serializer: ReportSerializer) if @report.save!
      end

      def destroy
        authorize!(:destroy, @report, message: I18n.t('unauthorized.destroy.report'))
        render json: { message: I18n.t('report.successful_delete') }, status: :ok if @report.destroy!
      end

      private

      def set_report
        @report = Report.find(params[:id])
      end

      def report_params
        params.require(:report).permit(:name, :quicksight_embed_src, :quicksight_dashboard_id, :organization_id)
      end
    end
  end
end
