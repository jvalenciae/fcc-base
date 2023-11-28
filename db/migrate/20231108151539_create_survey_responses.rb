class CreateSurveyResponses < ActiveRecord::Migration[7.0]
  def change
    create_table :survey_responses, id: :uuid do |t|
      t.string :response_id, null: false
      t.jsonb :json_response, null: false
      t.date :date, null: false
      t.references :survey, null: false, foreign_key: true, type: :uuid
      t.references :student, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :survey_responses, :response_id, unique: true
  end
end
