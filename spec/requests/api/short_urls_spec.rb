# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShortUrls' do
  describe 'POST #create' do
    let(:valid_url) { 'http://example.com' }
    let(:invalid_url) { '' }
    let!(:admin_user) { create(:user, :super_admin) }

    context 'when the request is valid' do
      it 'creates a new ShortUrl' do
        expect do
          post '/api/v1/short_urls', params: { url: valid_url }, headers: authenticated_header(admin_user)
        end.to change(ShortUrl, :count).by(1)
      end

      it 'returns a success response' do
        post '/api/v1/short_urls', params: { url: valid_url }, headers: authenticated_header(admin_user)
        expect(response).to have_http_status(:success)
      end

      it 'returns the created short URL data' do
        post '/api/v1/short_urls', params: { url: valid_url }, headers: authenticated_header(admin_user)
        expect(json_response['short_url']['original_url']).to eq(valid_url)
        expect(json_response['short_url']).to have_key('shortened_url')
      end
    end

    context 'when the request is invalid' do
      it 'does not create a new ShortUrl' do
        expect do
          post '/api/v1/short_urls', params: { url: invalid_url }, headers: authenticated_header(admin_user)
        end.not_to change(ShortUrl, :count)
      end

      it 'returns an unprocessable entity response' do
        post '/api/v1/short_urls', params: { url: invalid_url }, headers: authenticated_header(admin_user)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error messages' do
        post '/api/v1/short_urls', params: { url: invalid_url }, headers: authenticated_header(admin_user)
        expect(json_response['error']).to include("Original url can't be blank")
      end
    end
  end

  describe 'GET #top100' do
    before do
      create_list(:short_url, 150)
    end

    it 'returns the top 100 most visited ShortUrls' do
      get '/api/v1/short_urls/top100', headers: authenticated_header(create(:user, :super_admin))

      expect(response).to have_http_status(:success)
      expect(json_response['data'].size).to eq(100)
    end
  end

  describe 'GET #redirect' do
    let!(:short_url) { create(:short_url, original_url: 'http://example.com') }
    let(:shortened_url) { IdToShortUrlService.new(short_url.id).call }

    context 'when the shortened URL is valid' do
      it 'redirects to the original URL and increments visits' do
        expect do
          get "/#{shortened_url}", headers: authenticated_header(create(:user, :super_admin))
        end.to change { short_url.reload.visits }.by(1)

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(short_url.original_url)
      end
    end

    context 'when the shortened URL is invalid' do
      let(:invalid_shortened_url) { 'invalidurl' }

      it 'returns a not found response' do
        get "/#{invalid_shortened_url}", headers: authenticated_header(create(:user, :super_admin))

        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq('URL not found')
      end
    end
  end
end
