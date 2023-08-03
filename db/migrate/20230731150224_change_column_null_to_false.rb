class ChangeColumnNullToFalse < ActiveRecord::Migration[7.0]
  def change
    change_column_null :organizations, :name, false
    change_column_null :organizations, :country, false
    change_column_null :organizations, :report_id, false
    change_column_null :branches, :name, false
    change_column_null :branches, :country, false
    change_column_null :branches, :city, false
    change_column_null :branches, :address, false
    change_column_null :branches, :phone_number, false
    change_column_null :users, :first_name, false
    change_column_null :users, :last_name, false
    change_column_null :users, :phone_number, false
    change_column_null :users, :country, false
    change_column_null :users, :role, false
  end
end
