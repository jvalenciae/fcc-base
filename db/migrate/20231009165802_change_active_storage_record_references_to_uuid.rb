class ChangeActiveStorageRecordReferencesToUuid < ActiveRecord::Migration[7.0]
  def up
    # Delete all attachments before updating record_id
    ActiveStorage::Attachment.delete_all

    remove_column :active_storage_attachments, :record_id
    add_column :active_storage_attachments, :record_id, :uuid, null: false
    add_index :active_storage_attachments, [:record_type, :record_id, :name, :blob_id], name: 'index_active_storage_attachments_uniqueness', unique: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
