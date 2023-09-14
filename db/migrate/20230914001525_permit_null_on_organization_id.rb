class PermitNullOnOrganizationId < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :organization_id, :bigint, null: true
  end
end
