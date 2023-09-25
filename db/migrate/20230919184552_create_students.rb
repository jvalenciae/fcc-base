class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students, id: :uuid do |t|
      # Personal Info
      t.string :id_number, null: false
      t.string :name, null: false
      t.string :birthplace, null: false
      t.date :birthdate, null: false
      t.integer :gender, null: false
      # Student Info
      t.integer :tshirt_size, null: false
      t.integer :shorts_size, null: false
      t.integer :socks_size, null: false
      t.integer :shoe_size, null: false
      t.string :favourite_colour, null: false
      t.string :favourite_food, null: false
      t.string :favourite_sport, null: false
      t.string :favourite_place, null: false
      t.string :feeling_when_playing_soccer, null: false
      # Contact Info
      t.string :country, null: false
      t.string :city, null: false
      t.string :neighborhood, null: false
      t.string :address, null: false
      t.string :school, null: false
      t.string :extracurricular_activities, null: false
      t.integer :health_coverage, null: false
      # Vulnerability Info
      t.boolean :displaced, default: false, null: false
      t.string :displacement_origin
      t.string :displacement_reason
      t.boolean :lives_with_reinserted_familiar, default: false, null: false
      t.string :program
      t.boolean :beneficiary_of_another_foundation, default: false, null: false
      # Student State
      t.integer :status, default: 0, null: false
      t.date :withdrawal_date
      t.string :withdrawal_reason

      t.references :group, type: :uuid, null: false, foreign_key: true
      t.references :branch, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
