class CreateUploadedFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :uploaded_files, id: :uuid do |t|

      t.timestamps
    end
  end
end
