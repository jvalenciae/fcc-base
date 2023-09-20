class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups, id: :uuid do |t|
      t.integer :category, null: false
      t.references :branch, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
