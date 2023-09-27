class AddDeletedAtToSupervisors < ActiveRecord::Migration[7.0]
  def change
    add_column :supervisors, :deleted_at, :datetime
    add_index :supervisors, :deleted_at
  end
end
