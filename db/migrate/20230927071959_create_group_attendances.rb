class CreateGroupAttendances < ActiveRecord::Migration[7.0]
  def change
    create_table :group_attendances, id: :uuid do |t|
      t.date :date, null: false
      t.references :group, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
