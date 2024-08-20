FactoryBot.define do
  factory :transaction do
    transaction_type { 0 }
    merchant { "merchant" }
    user
    amount { 1.5 }
  end
end
