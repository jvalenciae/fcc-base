# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PullTitleFromUrlJob do
  let(:short_url) { create(:short_url, original_url: 'https://example.com', title: nil) }

  before do
    allow(URI).to receive(:parse).and_return(double(open: '<html><title>Example Title</title></html>'))
  end

  describe '#perform' do
    context 'when the URL exists' do
      it 'fetches the title and updates the ShortUrl record' do
        described_class.new.perform(short_url.id)

        expect(short_url.reload.title).to eq('Example Title')
      end

      it 'handles cases where the title tag is empty' do
        allow(URI).to receive(:parse).and_return(double(open: '<html><title></title></html>'))

        described_class.new.perform(short_url.id)

        expect(short_url.reload.title).to eq('No Title Found')
      end

      it 'handles cases where the title tag is missing' do
        allow(URI).to receive(:parse).and_return(double(open: '<html><body>No title here</body></html>'))

        described_class.new.perform(short_url.id)

        expect(short_url.reload.title).to eq('No Title Found')
      end
    end

    context 'when the URL does not exist' do
      it 'does not raise an error and returns nil' do
        expect { described_class.new.perform(nil) }.not_to raise_error
      end
    end
  end
end
