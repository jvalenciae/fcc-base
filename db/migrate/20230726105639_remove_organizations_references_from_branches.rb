class RemoveOrganizationsReferencesFromBranches < ActiveRecord::Migration[7.0]
  def change
    remove_reference :branches, :organization, foreign_key: true
  end
end
