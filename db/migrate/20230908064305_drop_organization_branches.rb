class DropOrganizationBranches < ActiveRecord::Migration[7.0]
  def change
    drop_table :organization_branches
  end
end
