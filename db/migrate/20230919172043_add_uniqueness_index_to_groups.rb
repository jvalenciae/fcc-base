class AddUniquenessIndexToGroups < ActiveRecord::Migration[7.0]
  def change
    add_index :groups, [:name, :category, :branch_id], unique: true
  end
end
