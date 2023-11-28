class AddKindOfMeasurementToSurveyResponses < ActiveRecord::Migration[7.0]
  def change
    add_column :survey_responses, :kind_of_measurement, :string, null: false
    add_column :survey_responses, :scores, :jsonb, null: false
  end
end
