# frozen_string_literal: true

class User < ApplicationRecord
  self.implicit_order_column = 'created_at'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  validates :first_name, :last_name, :email, :phone_number, :country, :role, presence: true
  validate :validate_branches_belongs_to_organization

  before_validation :set_random_password, on: :create
  after_create :generate_custom_reset_password_token

  PASSWORD_PATTERN = %r{\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-\=\[\]{}|\'"/\.,`<>:;?~])}.freeze
  validates :password,
            presence: true,
            format: {
              with: PASSWORD_PATTERN,
              message: I18n.t('user.errors.weak_password')
            }, allow_blank: true

  validates :reset_password_token, uniqueness: true, allow_nil: true

  belongs_to :organization, optional: true

  has_many :user_branches, dependent: :destroy
  has_many :branches, through: :user_branches
  has_many :groups, through: :branches

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

  include PgSearch::Model
  pg_search_scope :search_by_q,
                  against: %i[first_name last_name phone_number],
                  using: {
                    tsearch: { prefix: true }
                  }, ignoring: :accents

  scope :by_role, lambda { |role|
    return all if role.blank?

    case role
    when 'super_admin'
      where(role: SUPER_ADMIN_ROLES.keys)
    when 'admin'
      where(role: ADMIN_ROLES.keys)
    when 'member'
      where(role: MEMBER_ROLES.keys)
    else
      where(role: role)
    end
  }

  scope :by_organization_ids, lambda { |organization_ids|
    return all if organization_ids.blank?

    where(organization_id: organization_ids)
  }

  scope :by_branch_ids, lambda { |branch_ids|
    return all if branch_ids.blank?

    joins(:branches).where(branches: { id: branch_ids }).distinct
  }

  scope :by_categories, lambda { |categories|
    return all if categories.blank?

    joins(:groups).where({ groups: { category: categories } }).distinct
  }

  scope :by_departments, lambda { |departments, country|
    return all if departments.blank?
    return all if country.blank?

    joins(:branches).where({ branches: { department: departments, country: country } }).distinct
  }

  def super_admin?
    SUPER_ADMIN_ROLES.include?(role)
  end

  def admin?
    ADMIN_ROLES.include?(role)
  end

  def member?
    MEMBER_ROLES.include?(role)
  end

  def branches_in_charge
    branches.count
  end

  def students_in_charge
    branches.map(&:groups).flatten.map(&:students).flatten.count
  end

  def generate_reset_password_token(expiration_duration: 0.days)
    token = Devise.token_generator.generate(User, :reset_password_token).last
    self.reset_password_token = token
    self.reset_password_sent_at = expiration_duration.from_now.utc
    save!
  end

  def validate_reset_password_token
    errors.add(:reset_password_token, I18n.t('errors.message.not_present')) if reset_password_token.blank?
    errors.add(:reset_password_token, I18n.t('errors.message.has_expired')) unless reset_password_period_valid?
  end

  private

  def validate_branches_belongs_to_organization
    return if branches.blank?

    return if branches.all? { |branch| branch.organization == organization }

    errors.add(:branches, I18n.t('user.errors.branches_belongs_to_organization'))
  end

  def set_random_password
    self.password = password.presence || "#{SecureRandom.base58(30)}!"
  end

  def generate_custom_reset_password_token
    generate_reset_password_token(expiration_duration: 7.days)
  end
end
