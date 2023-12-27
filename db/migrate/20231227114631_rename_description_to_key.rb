class RenameDescriptionToKey < ActiveRecord::Migration[7.0]
  def change
    rename_column :surveys, :description, :key
    change_column_null :surveys, :key, true
  end
end
