class CreateBranches < ActiveRecord::Migration[7.0]
  def change
    create_table :branches do |t|
      t.string :name
      t.string :country
      t.string :city
      t.string :address
      t.string :phone_number
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
