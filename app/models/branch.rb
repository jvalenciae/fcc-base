class Branch < ApplicationRecord
  validates :name, :country, :city, :address, :phone_number, presence: true

  belongs_to :organization

  scope :by_organization_ids, lambda { |organization_ids|
    return all if organization_ids.blank?

    where(organization_id: organization_ids)
  }
end