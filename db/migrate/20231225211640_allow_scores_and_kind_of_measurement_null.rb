class AllowScoresAndKindOfMeasurementNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :survey_responses, :scores, true
    change_column_null :survey_responses, :kind_of_measurement, true
  end
end
