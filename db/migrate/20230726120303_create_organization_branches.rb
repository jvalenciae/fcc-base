class CreateOrganizationBranches < ActiveRecord::Migration[7.0]
  def change
    create_table :organization_branches do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :branch, null: false, foreign_key: true

      t.timestamps
    end
  end
end
