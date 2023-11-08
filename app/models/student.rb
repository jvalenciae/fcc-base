# frozen_string_literal: true

class Student < ApplicationRecord
  self.implicit_order_column = 'created_at'

  acts_as_paranoid

  validates :id_number, :name, :birthplace, :birthdate, :gender, :tshirt_size, :shorts_size, :socks_size, :shoe_size,
            :favourite_colour, :favourite_food, :favourite_sport, :favourite_place, :feeling_when_playing_soccer, :city,
            :country, :neighborhood, :address, :school, :health_coverage, :id_type, :study_day, :grade, :department,
            :height, :weight, presence: true

  validate :validate_group_belongs_to_branch

  belongs_to :group
  belongs_to :branch
  has_many :supervisors, dependent: nil
  accepts_nested_attributes_for :supervisors
  has_many :student_attendances, dependent: :destroy

  before_create :set_default_status

  GENDERS = {
    male: 0,
    female: 1
  }.with_indifferent_access.freeze

  enum gender: GENDERS

  STATUSES = {
    active: 0,
    withdrawn: 1
  }.with_indifferent_access.freeze

  enum status: STATUSES

  HEALTH_COVERAGES = {
    sisben: 0,
    eps: 1
  }.with_indifferent_access.freeze

  enum health_coverage: HEALTH_COVERAGES

  scope :by_branch_ids, lambda { |branch_ids|
    return all if branch_ids.blank?

    where(branch_id: branch_ids)
  }

  scope :by_categories, lambda { |categories|
    return all if categories.blank?

    joins(:group).where(group: { category: categories })
  }

  scope :by_group_ids, lambda { |group_ids|
    return all if group_ids.blank?

    where(group_id: group_ids)
  }

  scope :by_statuses, lambda { |statuses|
    return all if statuses.blank?

    where(status: statuses)
  }

  scope :by_tshirt_sizes, lambda { |tshirt_sizes|
    return all if tshirt_sizes.blank?

    where(tshirt_size: tshirt_sizes)
  }

  scope :by_shorts_sizes, lambda { |shorts_sizes|
    return all if shorts_sizes.blank?

    where(shorts_size: shorts_sizes)
  }

  scope :by_socks_sizes, lambda { |socks_sizes|
    return all if socks_sizes.blank?

    where(socks_size: socks_sizes)
  }

  scope :by_shoe_sizes, lambda { |shoe_sizes|
    return all if shoe_sizes.blank?

    where(shoe_size: shoe_sizes)
  }

  scope :by_health_coverages, lambda { |health_coverages|
    return all if health_coverages.blank?

    where(health_coverage: health_coverages)
  }

  scope :by_beneficiary_of_another_foundation, lambda { |beneficiary_of_another_foundation|
    return all if beneficiary_of_another_foundation.to_s.blank?

    where(beneficiary_of_another_foundation: beneficiary_of_another_foundation.to_boolean)
  }

  scope :by_displaced, lambda { |displaced|
    return all if displaced.to_s.blank?

    where(displaced: displaced.to_boolean)
  }

  scope :by_lives_with_reinserted_familiar, lambda { |lives_with_reinserted_familiar|
    return all if lives_with_reinserted_familiar.to_s.blank?

    where(lives_with_reinserted_familiar: lives_with_reinserted_familiar.to_boolean)
  }

  private

  def set_default_status
    self.status = status.presence || STATUSES.keys.first
  end

  def validate_group_belongs_to_branch
    return if group.blank?
    return if group.branch == branch

    errors.add(:group, I18n.t('student.errors.group_belongs_to_branch'))
  end
end
