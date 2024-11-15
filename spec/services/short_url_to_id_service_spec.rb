# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShortUrlToIdService do
  let(:service) { described_class.new(short_url) }

  describe '#call' do
    context 'when given a valid short URL' do
      let(:short_url) { 'b9' }

      it 'correctly decodes the short URL to the original ID' do
        result = service.call
        expected_id = 123
        expect(result).to eq(expected_id)
      end
    end

    context 'when the short URL is a single character' do
      let(:short_url) { 'a' }

      it 'returns the correct ID' do
        result = service.call
        expect(result).to eq(0)
      end
    end

    context 'when the short URL contains upper-case letters' do
      let(:short_url) { 'Bz' }

      it 'handles upper-case letters correctly' do
        result = service.call
        expected_id = 1699
        expect(result).to eq(expected_id)
      end
    end

    context 'when the short URL contains numbers' do
      let(:short_url) { '2g9' }

      it 'handles numbers correctly' do
        result = service.call
        expected_id = 208_009
        expect(result).to eq(expected_id)
      end
    end

    context 'when the short URL is empty' do
      let(:short_url) { '' }

      it 'returns 0' do
        result = service.call
        expect(result).to eq(0)
      end
    end
  end
end
