class AddOrganizationToBranches < ActiveRecord::Migration[7.0]
  def change
    add_reference :branches, :organization, null: false, foreign_key: true
  end
end
