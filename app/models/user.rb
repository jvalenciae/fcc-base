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
end
