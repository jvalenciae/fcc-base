class AddBranchReferencesToSurveyResponses < ActiveRecord::Migration[7.0]
  def change
    add_reference :survey_responses, :branch, foreign_key: true, type: :uuid, null: true
  end
end
