module Api
  module V1
    class BranchesController < ApiController
      def index
        branches = Branch.by_organization_ids(branch_params[:organization_id])

        render_response(data: branches, serializer: BranchSerializer)
      end

      private

      def branch_params
        params.permit(:organization_id)
      end
    end
  end
end
