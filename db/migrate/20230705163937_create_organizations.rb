class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :country
      t.string :report_id

      t.timestamps
    end
  end
end
