# frozen_string_literal: true

module Api
  module V1
    class GroupsController < ApiController
      before_action :set_group, only: %i[show update destroy]
      before_action :set_groups, only: %i[index export]

      def index
        @groups, meta = paginate_resources(@groups)
        render_response(data: @groups, serializer: GroupSerializer, meta: meta)
      end

      def show
        authorize!(:read, @group, message: I18n.t('unauthorized.read.group'))
        render_response(data: @group, serializer: GroupSerializer)
      end

      def create
        @group = Group.new(group_params)
        authorize!(:create, @group, message: I18n.t('unauthorized.create.group'))
        render_response(data: @group, serializer: GroupSerializer) if @group.save!
      end

      def update
        @group.assign_attributes(group_params)
        authorize!(:update, @group, message: I18n.t('unauthorized.update.group'))
        render_response(data: @group, serializer: GroupSerializer) if @group.save!
      end

      def destroy
        authorize!(:destroy, @group, message: I18n.t('unauthorized.destroy.group'))
        render json: { message: I18n.t('group.successful_delete') }, status: :ok if @group.destroy!
      end

      def categories
        @categories = Group::CATEGORIES.keys
        render_response(data: @categories, serializer: CategorySerializer)
      end

      def export
        respond_to do |format|
          format.csv do
            response.headers['Content-Type'] = 'text/csv'
            response.headers['Content-Disposition'] = 'attachment; filename=groups.csv'
            csv_data = GroupsExportService.call(@groups)

            render plain: csv_data
          end
        end
      end

      private

      def set_group
        @group = Group.find(params[:id])
      end

      def set_groups
        # rubocop:disable Naming/MemoizedInstanceVariableName
        @groups ||= Group.accessible_by(current_ability)
                         .by_categories(params[:categories])
                         .by_branch_ids(params[:branch_ids])
        # rubocop:enable Naming/MemoizedInstanceVariableName
      end

      def group_params
        params.require(:group).permit(
          :category, :name, :branch_id
        )
      end
    end
  end
end
