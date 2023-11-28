class CreateSurveys < ActiveRecord::Migration[7.0]
  def change
    create_table :surveys, id: :uuid do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.string :form_id, null: false
      t.references :organization, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
