# frozen_string_literal: true

class Api::V1::TransactionsController < ApiController
  def index
    transactions = current_user.transactions.order('created_at DESC')
    transactions = transactions.by_date(params[:start_date], params[:end_date])
    render json: transactions
  end

  def create
    transaction = current_user.transactions.new(transaction_params)

    if transaction.save
      # Create a process to do calculations
      render json: transaction, status: :created
    else
      render json: { message: 'Transaction could not be created' }, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:transaction_type, :amount, :merchant)
  end
end
