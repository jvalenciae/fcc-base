# frozen_string_literal: true

class User < ApplicationRecord
  self.implicit_order_column = 'created_at'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist


  has_many :transactions

  validates :first_name, :last_name, :email, :phone_number, :country, :role, presence: true

  validate :balance_is_positive 

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

  ROLES = {
    super_admin: 0,
    user: 1
  }.with_indifferent_access.freeze

  enum role: ROLES

  include PgSearch::Model
  pg_search_scope :search_by_q,
                  against: %i[first_name last_name phone_number],
                  using: {
                    tsearch: { prefix: true }
                  }, ignoring: :accents

  scope :by_role, lambda { |role|
    return all if role.blank?

    where(role: role)
  }

  def super_admin?
    role == 'super_admin'
  end

  def user?
    role == 'user'
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

  def set_random_password
    self.password = password.presence || "#{SecureRandom.base58(30)}!"
  end

  def generate_custom_reset_password_token
    generate_reset_password_token(expiration_duration: 7.days)
  end

  def balance_is_positive
    balance is positive
  end
end
