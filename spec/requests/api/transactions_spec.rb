# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Transactions' do
  describe '#index' do
    let(:user) { create(:user, role: :super_admin) }
    let!(:transactions) { create_list(:transaction, 10, user: user) }

    context 'user is logged in' do
      before do
        get '/api/v1/transactions', headers: authenticated_header(user)
      end

      it 'gives a valid response' do
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body).size).to eq(transactions.size)
        expect(JSON.parse(response.body).first['transaction_type']).to eq(0)

        json_response = JSON.parse(response.body)
        (0...json_response.size - 1).each do |index|
          expect(json_response[index]['created_at']).to be >= json_response[index + 1]['created_at']
        end
      end
    end

    context 'user is not logged in' do
      before do
        get '/api/v1/transactions'
      end

      it 'gives a not authenticated' do
        expect(response.status).to eq(401)
      end
    end
  end
end
