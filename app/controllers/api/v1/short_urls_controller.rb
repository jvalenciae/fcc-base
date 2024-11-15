# frozen_string_literal: true

class Api::V1::ShortUrlsController < ApiController
  skip_before_action :authenticate_user!

  def create
    short_url = ShortUrl.new(original_url: url_params[:url])

    if short_url.save
      render json: { short_url: short_url }
    else
      render json: { error: short_url.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def top100
    render json: { data: ShortUrl.top100 }
  end

  def redirect
    shortened_url = params[:shortened_url]

    id = ShortUrlToIdService.call(shortened_url)

    short_url = ShortUrl.find_by(id: id)

    if short_url
      short_url.increment!(:visits)
      redirect_to short_url.original_url, allow_other_host: true
    else
      render plain: 'URL not found', status: :not_found
    end
  end

  private

  def url_params
    params.permit(:url)
  end
end
