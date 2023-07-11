class Organization < ApplicationRecord
  validates :name, :country, :report_id, presence: true

  has_one_attached :logo
  has_many :branches, dependent: :destroy
end
