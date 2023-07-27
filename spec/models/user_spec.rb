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

    describe '#validate_branches_belongs_to_organizations' do
      let(:user) { create(:user) }
      let(:organization) { create(:organization) }
      let(:valid_branch) { create(:branch, organizations: [organization]) }
      let(:invalid_branch) { create(:branch) }

      context 'when all branches belong to user organizations' do
        before do
          user.organizations << organization
          user.branches << valid_branch
        end

        it 'does not add errors' do
          user.valid?
          expect(user.errors[:branches]).to be_empty
        end
      end

      context 'when some branches do not belong to user organizations' do
        before do
          user.organizations << organization
          user.branches << invalid_branch
        end

        it 'adds an error message' do
          user.valid?
          expect(user.errors[:branches]).to include("Some branches don't belong to user's organizations")
        end
      end

      context 'when user has no branches' do
        it 'does not add errors' do
          user.valid?
          expect(user.errors[:branches]).to be_empty
        end
      end
    end
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

  describe '#generate_reset_password_token' do
    let(:user) { create(:user) }

    before do
      allow(Devise.token_generator).to receive(:generate).and_return(%w[raw hashed])
      user.generate_reset_password_token
    end

    it 'generates a reset password token' do
      expect(user.reset_password_token).to eq('hashed')
    end

    it 'sets the reset password sent time' do
      expect(user.reset_password_sent_at).not_to be_nil
    end
  end

  describe '#validate_reset_password_token' do
    let(:user) { build(:user) }

    context 'when the reset password token is present and valid' do
      before do
        user.reset_password_token = 'valid_token'
        allow(user).to receive(:reset_password_period_valid?).and_return(true)
        user.validate_reset_password_token
      end

      it 'does not add an error' do
        expect(user.errors[:reset_password_token]).to be_empty
      end
    end

    context 'when the reset password token is present but expired' do
      before do
        user.reset_password_token = 'expired_token'
        allow(user).to receive(:reset_password_period_valid?).and_return(false)
        user.validate_reset_password_token
      end

      it 'adds an error' do
        expect(user.errors[:reset_password_token]).to include('has expired')
      end
    end

    context 'when the reset password token is not present' do
      before do
        user.reset_password_token = nil
        user.validate_reset_password_token
      end

      it 'does not add an error' do
        expect(user.errors[:reset_password_token]).to include('not present')
      end
    end
  end
end
