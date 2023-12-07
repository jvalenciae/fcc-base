# frozen_string_literal: true

module Api
  module V1
    class AttendancesController < ApiController
      before_action :set_attendance, only: %i[show destroy]

      def index
        @attendances = GroupAttendance.accessible_by(current_ability)
                                      .by_branch_ids(params[:branch_ids])
                                      .by_group_ids(params[:group_ids])
                                      .by_date(params[:date])
        @attendances, meta = paginate_resources(@attendances)
        render_response(data: @attendances, serializer: GroupAttendanceSerializer, meta: meta)
      end

      def show
        authorize!(:read, @attendance, message: I18n.t('unauthorized.read.attendance'))
        render_response(data: @attendance, serializer: GroupAttendanceSerializer)
      end

      def create
        @attendance, student_attendances = CreateAttendanceService.call(attendance_params)
        authorize!(:create, @attendance, message: I18n.t('unauthorized.create.attendance'))
        authorize_multiple!(:create, student_attendances, I18n.t('unauthorized.create.attendance'))
        @attendance.student_attendances = student_attendances if @attendance.save!
        render_response(data: @attendance, serializer: GroupAttendanceSerializer) if @attendance.save!
      end

      def update
        @attendance, student_attendances = CreateAttendanceService.call(
          attendance_params.except(:group_id).merge({ id: params[:id] })
        )
        authorize!(:update, @attendance, message: I18n.t('unauthorized.update.attendance'))
        authorize_multiple!(:update, student_attendances, I18n.t('unauthorized.update.attendance'))
        @attendance.student_attendances = student_attendances if @attendance.save!
        render_response(data: @attendance, serializer: GroupAttendanceSerializer) if @attendance.save!
      end

      def destroy
        authorize!(:destroy, @attendance, message: I18n.t('unauthorized.destroy.attendance'))
        render json: { message: I18n.t('attendance.successful_delete') }, status: :ok if @attendance.destroy!
      end

      private

      def attendance_params
        params.require(:group_attendance).permit(
          :date, :group_id, { attendances: %i[student_id present] }
        )
      end

      def set_attendance
        @attendance = GroupAttendance.find(params[:id])
      end

      def authorize_multiple!(action, resources, message)
        resources.each { |resource| authorize!(action, resource, message) }
      end
    end
  end
end
