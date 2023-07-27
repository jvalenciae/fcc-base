# frozen_string_literal: true

class Branch < ApplicationRecord
  validates :name, :country, :city, :address, :phone_number, presence: true

  has_many :organization_branches, dependent: :destroy
  has_many :organizations, through: :organization_branches

  has_many :user_branches, dependent: :destroy
  has_many :users, through: :user_branches

  scope :by_organization_ids, lambda { |organization_ids|
    return all if organization_ids.blank?

    joins(:organizations).where(organizations: { id: organization_ids })
  }
end
