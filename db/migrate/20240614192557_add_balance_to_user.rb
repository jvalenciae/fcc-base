class AddBalanceToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :balance, :float, default: 0
  end
end
