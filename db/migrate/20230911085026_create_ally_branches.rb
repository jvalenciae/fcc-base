class CreateAllyBranches < ActiveRecord::Migration[7.0]
  def change
    create_table :ally_branches do |t|
      t.references :ally, null: false, foreign_key: true
      t.references :branch, null: false, foreign_key: true

      t.timestamps
    end
  end
end
