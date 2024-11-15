# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IdToShortUrlService do
  let(:service) { described_class.new(id) }

  describe '#call' do
    context 'when the ID is 0' do
      let(:id) { 0 }

      it 'returns the first character of the alphabet' do
        result = service.call
        expect(result).to eq('a')
      end
    end

    context 'when the ID is a single-digit number' do
      let(:id) { 1 }

      it 'returns the correct short URL' do
        result = service.call
        expect(result).to eq('b')
      end
    end

    context 'when the ID is a large number' do
      let(:id) { 238_327 }

      it 'returns the correct short URL' do
        result = service.call
        expect(result).to eq('999')
      end
    end
  end
end
