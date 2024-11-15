# frozen_string_literal: true

class PullTitleFromUrlJob
  include Sidekiq::Job
  sidekiq_options retry: 3, dead: false

  def perform(url_id)
    url = ShortUrl.find_by(id: url_id)
    return unless url

    begin
      doc = Nokogiri::HTML(URI.parse(url.original_url).open)
      title = doc.css('title').text.strip.presence || 'No Title Found'
      url.update(title: title)
    rescue StandardError => e
      Rails.logger.error("Unexpected error in PullTitleFromUrlJob for URL ID: #{url_id}, Error: #{e.message}")
    end
  end
end
