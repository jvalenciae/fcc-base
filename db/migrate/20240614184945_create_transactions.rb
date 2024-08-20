class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.integer :transaction_type
      t.string :merchant
      t.references :user, null: false, foreign_key: true
      t.float :amount

      t.timestamps
    end
  end
end
