class PermitNullOnSurveyResponseStudentId < ActiveRecord::Migration[7.0]
  def change
    change_column_null :survey_responses, :student_id, true
  end
end
