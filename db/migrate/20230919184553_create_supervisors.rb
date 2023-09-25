class CreateSupervisors < ActiveRecord::Migration[7.0]
  def change
    create_table :supervisors, id: :uuid do |t|
      t.string :id_number, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.date :birthdate, null: false
      t.string :phone_number, null: false
      t.string :profession, null: false
      t.integer :relationship, null: false

      t.references :student, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
