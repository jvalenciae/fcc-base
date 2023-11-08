# frozen_string_literal: true

module Api
  module V1
    class StudentsController < ApiController
      before_action :set_student, only: %i[show update destroy]
      before_action :set_students, only: %i[index export]

      def index
        @students, meta = paginate_resources(@students)
        render_response(data: @students, serializer: Students::SmallSerializer, meta: meta)
      end

      def show
        authorize!(:read, @student, message: I18n.t('unauthorized.read.student'))
        render_response(data: @student, serializer: Students::BigSerializer)
      end

      def create
        @student = Student.new(student_params)
        authorize!(:create, @student, message: I18n.t('unauthorized.create.student'))
        render_response(data: @student, serializer: Students::BigSerializer) if @student.save!
      end

      def update
        @student.assign_attributes(student_params)
        authorize!(:update, @student, message: I18n.t('unauthorized.update.student'))
        render_response(data: @student, serializer: Students::BigSerializer) if @student.save!
      end

      def destroy
        authorize!(:destroy, @student, message: I18n.t('unauthorized.destroy.student'))
        render json: { message: I18n.t('student.successful_delete') }, status: :ok if @student.destroy!
      end

      def export
        respond_to do |format|
          format.csv do
            response.headers['Content-Type'] = 'text/csv'
            response.headers['Content-Disposition'] = 'attachment; filename=students.csv'
            csv_data = StudentsExportService.call(@students)

            render plain: csv_data
          end
        end
      end

      def import
        if params[:file].blank?
          render json: { message: I18n.t('student.import.missing_file') },
                 status: :bad_request and return
        end

        uploaded_file = UploadedFile.new
        uploaded_file.file.attach(params[:file])
        uploaded_file.save!

        StudentsImportJob.perform_async(uploaded_file.file.url)
        render json: { message: I18n.t('student.import.started') }, status: :ok
      end

      private

      def set_student
        @student = Student.find(params[:id])
      end

      def set_students
        @students = Student.accessible_by(current_ability)
        @students = StudentsFilterService.call(@students, params)
      end

      def student_params
        params.require(:student).permit(
          :id_number, :name, :birthplace, :birthdate, :gender, :tshirt_size, :shorts_size, :socks_size, :shoe_size,
          :favourite_colour, :favourite_food, :favourite_place, :favourite_sport, :feeling_when_playing_soccer,
          :country, :city, :neighborhood, :address, :school, :extracurricular_activities, :health_coverage, :displaced,
          :desplacement_origin, :desplacement_reason, :lives_with_reinserted_familiar, :program,
          :beneficiary_of_another_foundation, :status, :withdrawal_date, :withdrawal_reason, :group_id, :branch_id,
          :grade, :department, :height, :weight, :id_type, :study_day, :eps, :lives_with_parent,
          supervisors_attributes: %i[id_number name email birthdate phone_number profession relationship]
        )
      end
    end
  end
end
