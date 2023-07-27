# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  validates :first_name, :last_name, :email, :phone_number, :country, :role, presence: true
  validate :validate_branches_belongs_to_organizations

  PASSWORD_PATTERN = %r{\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-\=\[\]{}|\'"/\.,`<>:;?~])}.freeze
  validates :password,
            presence: true,
            format: {
              with: PASSWORD_PATTERN,
              message: I18n.t('user.errors.weak_password')
            }, allow_blank: true

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

  def generate_reset_password_token
    token = Devise.token_generator.generate(User, :reset_password_token).last
    self.reset_password_token = token
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def validate_reset_password_token
    errors.add(:reset_password_token, 'not present') if reset_password_token.blank?
    errors.add(:reset_password_token, 'has expired') unless reset_password_period_valid?
  end

  private

  def validate_branches_belongs_to_organizations
    return if branches.blank?

    invalid_branches = branches.reject do |branch|
      branch.organizations.any? { |organization| organizations.include?(organization) }
    end

    return unless invalid_branches.any?

    errors.add(:branches, "Some branches don't belong to user's organizations")
  end
end
