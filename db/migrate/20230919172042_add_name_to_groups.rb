class AddNameToGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :groups, :name, :string, null: false, default: '1'
  end
end
