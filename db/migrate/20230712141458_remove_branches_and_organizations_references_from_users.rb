class RemoveBranchesAndOrganizationsReferencesFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_reference :users, :organization, foreign_key: true
    remove_reference :users, :branch, foreign_key: true
  end
end
