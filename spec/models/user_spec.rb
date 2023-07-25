# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:phone_number) }
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_presence_of(:role) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:user_organizations).dependent(:destroy) }
    it { is_expected.to have_many(:organizations).through(:user_organizations) }
    it { is_expected.to have_many(:user_branches).dependent(:destroy) }
    it { is_expected.to have_many(:branches).through(:user_branches) }
  end

  describe 'constants' do
    it 'returns SUPER_ADMIN_ROLES with correct values' do
      expect(User::SUPER_ADMIN_ROLES).to eq({ operative_director: 0 }.with_indifferent_access)
    end

    it 'returns ADMIN_ROLES with correct values' do
      expect(User::ADMIN_ROLES).to eq({ operations_coordinator: 1, zone_supervisor: 2 }.with_indifferent_access)
    end

    it 'returns MEMBER_ROLES with correct values' do
      expect(User::MEMBER_ROLES).to eq({ branch_leader: 3, trainer: 4 }.with_indifferent_access)
    end

    it 'returns all roles listed in ROLES constant' do
      all_roles = User::SUPER_ADMIN_ROLES.merge(User::ADMIN_ROLES).merge(User::MEMBER_ROLES)
      expect(User::ROLES).to eq(all_roles)
    end

    it 'returns ROLES as a frozen constant' do
      expect(User::ROLES).to be_frozen
    end
  end

  describe 'enums' do
    let(:user) { build(:user) }

    it {
      expect(user).to define_enum_for(:role).with_values(User::ROLES)
    }
  end

  describe '#super_admin?' do
    let(:user) { build(:user, role: User::SUPER_ADMIN_ROLES.keys.first) }

    it 'returns true if the role is a super_admin' do
      expect(user.super_admin?).to be(true)
    end

    it 'returns false if the role is not a super_admin' do
      user.role = User::ADMIN_ROLES.keys.first
      expect(user.super_admin?).to be(false)
    end
  end

  describe '#admin?' do
    let(:user) { build(:user, role: User::ADMIN_ROLES.keys.first) }

    it 'returns true if the role is an admin' do
      expect(user.admin?).to be(true)
    end

    it 'returns false if the role is not an admin' do
      user.role = User::MEMBER_ROLES.keys.first
      expect(user.admin?).to be(false)
    end
  end

  describe '#member?' do
    let(:user) { build(:user, role: User::MEMBER_ROLES.keys.first) }

    it 'returns true if the role is a member' do
      expect(user.member?).to be(true)
    end

    it 'returns false if the role is not a member' do
      user.role = User::ADMIN_ROLES.keys.first
      expect(user.member?).to be(false)
    end
  end
end
