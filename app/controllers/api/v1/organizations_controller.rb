# frozen_string_literal: true

module Api
  module V1
    class OrganizationsController < ApiController
      before_action :set_organization, only: %i[show update]

      def index
        @organizations = Organization.accessible_by(current_ability)
        render_response(data: @organizations, serializer: OrganizationSerializer)
      end

      def show
        authorize!(:read, @organization, message: I18n.t('unauthorized.read.organization'))
        render_response(data: @organization, serializer: OrganizationSerializer)
      end

      def create
        @organization = Organization.new(organization_params)
        authorize!(:create, @organization, message: I18n.t('unauthorized.create.organization'))
        render_response(data: @organization, serializer: OrganizationSerializer) if @organization.save!
      end

      def update
        @organization.assign_attributes(organization_params)
        authorize!(:update, @organization, message: I18n.t('unauthorized.update.organization'))
        render_response(data: @organization, serializer: OrganizationSerializer) if @organization.save!
      end

      private

      def set_organization
        @organization = Organization.find(params[:id])
      end

      def organization_params
        params.require(:organization).permit(
          :name, :country, :logo, :report_id
        )
      end
    end
  end
end
