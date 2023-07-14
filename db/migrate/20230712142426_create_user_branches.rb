class CreateUserBranches < ActiveRecord::Migration[7.0]
  def change
    create_table :user_branches do |t|
      t.references :user, null: false, foreign_key: true
      t.references :branch, null: false, foreign_key: true

      t.timestamps
    end
  end
end
