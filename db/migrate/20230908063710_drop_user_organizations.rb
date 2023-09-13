class DropUserOrganizations < ActiveRecord::Migration[7.0]
  def change
    drop_table :user_organizations
  end
end
