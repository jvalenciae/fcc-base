# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShortUrl do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:original_url) }
  end

  describe 'callbacks' do
    let(:short_url) { create(:short_url) }

    it 'calls generate_shortened_url after create' do
      expect(short_url.shortened_url).to be_present
    end

    it 'enqueues PullTitleFromUrlJob after create' do
      expect(PullTitleFromUrlJob).to have_enqueued_sidekiq_job(short_url.id)
    end
  end

  describe '.top100' do
    before do
      create_list(:short_url, 150, visits: Faker::Number.between(from: 0, to: 1000))
    end

    it 'returns at most 100 records' do
      expect(described_class.top100.count).to eq(100)
    end

    it 'orders by visits in descending order' do
      result = described_class.top100
      expect(result).to eq(result.sort_by(&:visits))
    end
  end
end
