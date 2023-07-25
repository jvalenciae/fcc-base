# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  validates :first_name, :last_name, :email, :phone_number, :country, :role, presence: true

  has_many :user_organizations, dependent: :destroy
  has_many :organizations, through: :user_organizations

  has_many :user_branches, dependent: :destroy
  has_many :branches, through: :user_branches

  SUPER_ADMIN_ROLES = {
    operative_director: 0
  }.with_indifferent_access.freeze

  ADMIN_ROLES = {
    operations_coordinator: 1,
    zone_supervisor: 2
  }.with_indifferent_access.freeze

  MEMBER_ROLES = {
    branch_leader: 3,
    trainer: 4
  }.with_indifferent_access.freeze

  ROLES = SUPER_ADMIN_ROLES.merge(ADMIN_ROLES).merge(MEMBER_ROLES).freeze

  enum role: ROLES

  def super_admin?
    SUPER_ADMIN_ROLES.include?(role)
  end

  def admin?
    ADMIN_ROLES.include?(role)
  end

  def member?
    MEMBER_ROLES.include?(role)
  end
end
