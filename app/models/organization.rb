# frozen_string_literal: true

class Organization < ApplicationRecord
  validates :name, :country, :report_id, presence: true

  has_one_attached :logo
  has_many :branches, dependent: :destroy

  has_many :user_organizations, dependent: :destroy
  has_many :users, through: :user_organizations
end
