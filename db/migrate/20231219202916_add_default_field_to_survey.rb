class AddDefaultFieldToSurvey < ActiveRecord::Migration[7.0]
  def change
    add_column :surveys, :default, :boolean, default: false, null: false
  end
end
