class ChangeNullTrueStudentsCountryAndDepartment < ActiveRecord::Migration[7.0]
  def change
    change_column_null :students, :country, true
    change_column_null :students, :department, true
  end
end
