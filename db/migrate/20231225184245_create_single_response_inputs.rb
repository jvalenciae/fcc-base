class CreateSingleResponseInputs < ActiveRecord::Migration[7.0]
  def change
    create_table :single_response_inputs do |t|
      t.string :question
      t.string :answer
      t.references :survey_response, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
