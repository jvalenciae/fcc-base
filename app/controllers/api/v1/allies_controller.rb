# frozen_string_literal: true

module Api
  module V1
    class AlliesController < ApiController
      before_action :set_ally, only: %i[show update]

      def index
        @allies = Ally.accessible_by(current_ability)
        @allies, meta = paginate_resources(@allies)
        render_response(data: @allies, serializer: AllySerializer, meta: meta)
      end

      def show
        authorize!(:read, @ally, message: I18n.t('unauthorized.read.ally'))
        render_response(data: @ally, serializer: AllySerializer)
      end

      def create
        @ally = Ally.new(ally_params)
        authorize!(:create, @ally, message: I18n.t('unauthorized.create.ally'))
        render_response(data: @ally, serializer: AllySerializer) if @ally.save!
      end

      def update
        @ally.assign_attributes(ally_params)
        authorize!(:update, @ally, message: I18n.t('unauthorized.update.ally'))
        render_response(data: @ally, serializer: AllySerializer) if @ally.save!
      end

      private

      def set_ally
        @ally = Ally.find(params[:id])
      end

      def ally_params
        params.require(:ally).permit(
          :name, :organization_id
        )
      end
    end
  end
end
