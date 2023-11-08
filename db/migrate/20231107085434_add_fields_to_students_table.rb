class AddFieldsToStudentsTable < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :id_type, :string, null: false, default: 'Registro civil'
    add_column :students, :study_day, :string, null: false, default: 'Mañana'
    add_column :students, :grade, :string, null: false, default: ' '
    add_column :students, :eps, :string
    add_column :students, :lives_with_parent, :boolean, null: false, default: 0
    add_column :students, :department, :string, null: false, default: ' '
    add_column :students, :height, :string, null: false, default: ' '
    add_column :students, :weight, :string, null: false, default: ' '

    change_column_null :students, :extracurricular_activities, true
  end
end
