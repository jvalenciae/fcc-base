class CreateStudentAttendances < ActiveRecord::Migration[7.0]
  def change
    create_table :student_attendances, id: :uuid do |t|
      t.date :date
      t.boolean :present, default: true, null: false
      t.references :group_attendance, type: :uuid, null: false, foreign_key: true
      t.references :student, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end

    add_column :student_attendances, :deleted_at, :datetime
    add_index :student_attendances, :deleted_at
  end
end
