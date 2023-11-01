class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports, id: :uuid do |t|
      t.string :name, null: false
      t.string :quicksight_embed_src, null: false
      t.string :quicksight_dashboard_id, null: false
      t.references :organization, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
