# frozen_string_literal: true

module Api
  module V1
    class TasksController < ApiController
      before_action :set_task, only: %i[show update destroy]

      def index
        @tasks = current_user.tasks.all
        @tasks, meta = paginate_resources(@tasks)
        render_response(data: @tasks, serializer: TaskSerializer, meta: meta)
      end

      def show
        authorize!(:read, @task, message: I18n.t('unauthorized.read.task'))
        render_response(data: @task, serializer: TaskSerializer)
      end

      def create
        @task = Task.new(task_params)
        authorize!(:create, @task, message: I18n.t('unauthorized.create.task'))
        return unless @task.save!

        render_response(data: @task, serializer: TaskSerializer)
      end

      def update
        @task.assign_attributes(task_params)
        authorize!(:update, @task, message: I18n.t('unauthorized.update.task'))
        render_response(data: @task, serializer: TaskSerializer) if @task.save!
      end

      def destroy
        authorize!(:destroy, @task, message: I18n.t('unauthorized.destroy.task'))
        render json: { message: I18n.t('task.successful_delete') }, status: :ok if @task.destroy!
      end

      private

      def set_task
        @task = Task.find(params[:id])
      end

      def task_params
        params.require(:task).permit(:title, :description, :due_date, :status, :user_id)
      end
    end
  end
end
