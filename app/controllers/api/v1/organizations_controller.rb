module Api
  module V1
    class OrganizationsController < ApiController
      def index
        organizations = Organization.all

        render_response(data: organizations, serializer: OrganizationSerializer)
      end
    end
  end
end
