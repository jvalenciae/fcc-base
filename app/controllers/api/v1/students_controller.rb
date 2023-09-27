# frozen_string_literal: true

module Api
  module V1
    class StudentsController < ApiController
      before_action :set_student, only: %i[show update destroy]

      def index
        @students = Student.accessible_by(current_ability)
        @students = StudentsFilterService.call(@students, params)
        @students, meta = paginate_resources(@students)
        render_response(data: @students, serializer: StudentSerializer, meta: meta)
      end

      def show
        authorize!(:read, @student, message: I18n.t('unauthorized.read.student'))
        render_response(data: @student, serializer: StudentSerializer)
      end

      def create
        @student = Student.new(student_params)
        authorize!(:create, @student, message: I18n.t('unauthorized.create.student'))
        render_response(data: @student, serializer: StudentSerializer) if @student.save!
      end

      def update
        @student.assign_attributes(student_params)
        authorize!(:update, @student, message: I18n.t('unauthorized.update.student'))
        render_response(data: @student, serializer: StudentSerializer) if @student.save!
      end

      def destroy
        authorize!(:destroy, @student, message: I18n.t('unauthorized.destroy.student'))
        render json: { message: 'Student successfully deleted.' }, status: :ok if @student.destroy!
      end

      private

      def set_student
        @student = Student.find(params[:id])
      end

      def student_params
        params.require(:student).permit(
          :id_number, :name, :birthplace, :birthdate, :gender, :tshirt_size, :shorts_size, :socks_size, :shoe_size,
          :favourite_colour, :favourite_food, :favourite_place, :favourite_sport, :feeling_when_playing_soccer,
          :country, :city, :neighborhood, :address, :school, :extracurricular_activities, :health_coverage, :displaced,
          :desplacement_origin, :desplacement_reason, :lives_with_reinserted_familiar, :program,
          :beneficiary_of_another_foundation, :status, :withdrawal_date, :withdrawal_reason, :group_id, :branch_id,
          supervisors_attributes: %i[id_number name email birthdate phone_number profession relationship]
        )
      end
    end
  end
end
