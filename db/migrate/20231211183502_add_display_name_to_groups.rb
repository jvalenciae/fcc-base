class AddDisplayNameToGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :groups, :display_name, :string
  end
end
