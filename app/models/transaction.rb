class Transaction < ApplicationRecord
  belongs_to :user

  validates :transaction_type, presence: true

  TRANSACTION_TYPES = {
    deposits: 0,
    withdrawals: 1,
    expenses: 2
  }.with_indifferent_access.freeze

  enum transaction_type: TRANSACTION_TYPES

  # scope by_dates -> where(created_at: start_date..end_date)
end
