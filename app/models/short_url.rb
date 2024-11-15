# frozen_string_literal: true

class ShortUrl < ApplicationRecord
  validates :original_url, presence: true

  after_create :generate_shortened_url, :enqueue_title_job

  scope :top100, -> { order(visits: :desc).limit(100) }

  private

  def generate_shortened_url
    update(shortened_url: IdToShortUrlService.call(id))
  end

  def enqueue_title_job
    PullTitleFromUrlJob.perform_async(id)
  end
end
