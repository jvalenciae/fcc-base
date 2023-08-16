# frozen_string_literal: true

module Api
  module V1
    class BranchesController < ApiController
      before_action :set_branch, only: %i[show update]

      def index
        @branches = Branch.accessible_by(current_ability).by_organization_ids(params[:organization_ids])
        @branches, meta = paginate_resources(@branches)
        render_response(data: @branches, serializer: BranchSerializer, meta: meta)
      end

      def show
        authorize!(:read, @branch, message: I18n.t('unauthorized.read.branch'))
        render_response(data: @branch, serializer: BranchSerializer)
      end

      def create
        @branch = Branch.new(branch_params)
        authorize!(:create, @branch, message: I18n.t('unauthorized.create.branch'))
        render_response(data: @branch, serializer: BranchSerializer) if @branch.save!
      end

      def update
        @branch.assign_attributes(branch_params)
        authorize!(:update, @branch, message: I18n.t('unauthorized.update.branch'))
        render_response(data: @branch, serializer: BranchSerializer) if @branch.save!
      end

      private

      def set_branch
        @branch = Branch.find(params[:id])
      end

      def branch_params
        params.require(:branch).permit(
          :name, :country, :city, :address, :phone_number, { organization_ids: [] }
        )
      end
    end
  end
end
