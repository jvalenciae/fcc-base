class AddOnDeleteCascadeToStudentAttendance < ActiveRecord::Migration[7.0]
  def up
    remove_foreign_key :student_attendances, :group_attendances
    add_foreign_key :student_attendances, :group_attendances, on_delete: :cascade
  end

  def down
    remove_foreign_key :student_attendances, :group_attendances
    add_foreign_key :student_attendances, :group_attendances
  end
end
