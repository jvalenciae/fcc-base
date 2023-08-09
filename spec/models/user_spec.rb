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

    describe '#password validations' do
      it 'is valid with a complex password' do
        user = build(:user, password: 'Password123!', password_confirmation: 'Password123!')
        expect(user).to be_valid
      end

      it 'is invalid with a weak password' do
        user = build(:user, password: 'weakpassword', password_confirmation: 'weakpassword')
        expect(user).not_to be_valid
        msg = 'must include at least one lowercase letter, one uppercase letter, one digit, and one special character'
        expect(user.errors[:password]).to include(msg)
      end

      it 'is invalid when password and password_confirmation do not match' do
        user = build(:user, password: 'Password123!', password_confirmation: 'Mismatched123!')
        expect(user).not_to be_valid
        expect(user.errors[:password_confirmation]).to include("doesn't match Password")
      end
    end
  end

  describe 'callbacks' do
    context 'when on: :create' do
      it 'sets a random password if password is blank' do
        user = build(:user, password: nil)
        user.save

        expect(user.password).not_to be_nil
      end

      it 'does not change the password if it is present' do
        existing_password = 'Password123!'
        user = build(:user, password: existing_password)
        user.save

        expect(user.password).to eq(existing_password)
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

  describe 'scopes' do
    describe '.search_by_q' do
      # rubocop:disable RSpec/IndexedLet
      let!(:user1) { create(:user, first_name: 'John', last_name: 'Doe', phone_number: '12345') }
      let!(:user2) { create(:user, first_name: 'Jane', last_name: 'Smith', phone_number: '67890') }
      let!(:user3) { create(:user, first_name: 'Alice', last_name: 'Wonderland', phone_number: '55555') }
      # rubocop:enable RSpec/IndexedLet

      it 'returns users matching the query' do
        expect(described_class.search_by_q('John')).to eq([user1])
        expect(described_class.search_by_q('Smith')).to eq([user2])
        expect(described_class.search_by_q('55555')).to eq([user3])
      end

      it 'ignores accents in the search' do
        expect(described_class.search_by_q('Álice')).to eq([user3])
      end
    end

    describe '.by_role' do
      let!(:super_admin_user) { create(:user, :super_admin) }
      let!(:admin_user) { create(:user, :admin) }
      let!(:member_user) { create(:user) }

      it 'returns users with the given role' do
        expect(described_class.by_role('super_admin')).to eq([super_admin_user])
        expect(described_class.by_role('admin')).to eq([admin_user])
        expect(described_class.by_role('member')).to eq([member_user])
      end

      it 'returns all users when role is blank' do
        expect(described_class.by_role('')).to eq([super_admin_user, admin_user, member_user])
        expect(described_class.by_role(nil)).to eq([super_admin_user, admin_user, member_user])
      end
    end

    describe '.by_organization_ids' do
      # rubocop:disable RSpec/IndexedLet
      let!(:organization1) { create(:organization) }
      let!(:organization2) { create(:organization) }
      let!(:user1) { create(:user, organizations: [organization1]) }
      let!(:user2) { create(:user, organizations: [organization2]) }
      let!(:user3) { create(:user, organizations: [organization1, organization2]) }
      let!(:user4) { create(:user) }
      # rubocop:enable RSpec/IndexedLet

      it 'returns users belonging to the specified organizations' do
        expect(described_class.by_organization_ids([organization1.id])).to eq([user1, user3])
        expect(described_class.by_organization_ids([organization2.id])).to eq([user2, user3])
        expect(described_class.by_organization_ids([organization1.id, organization2.id])).to eq([user1, user2, user3])
      end

      it 'returns all users when organization_ids is blank' do
        expect(described_class.by_organization_ids([])).to eq([user1, user2, user3, user4])
        expect(described_class.by_organization_ids(nil)).to eq([user1, user2, user3, user4])
      end
    end

    describe '.by_branch_ids' do
      # rubocop:disable RSpec/IndexedLet
      let!(:organization) { create(:organization) }
      let!(:branch1) { create(:branch, organizations: [organization]) }
      let!(:branch2) { create(:branch, organizations: [organization]) }
      let!(:user1) { create(:user, branches: [branch1], organizations: [organization]) }
      let!(:user2) { create(:user, branches: [branch2], organizations: [organization]) }
      let!(:user3) { create(:user, branches: [branch1, branch2], organizations: [organization]) }
      let!(:user4) { create(:user) }
      # rubocop:enable RSpec/IndexedLet

      it 'returns users belonging to the specified branches' do
        expect(described_class.by_branch_ids([branch1.id])).to eq([user1, user3])
        expect(described_class.by_branch_ids([branch2.id])).to eq([user2, user3])
        expect(described_class.by_branch_ids([branch1.id, branch2.id])).to eq([user1, user2, user3])
      end

      it 'returns all users when branch_ids is blank' do
        expect(described_class.by_branch_ids([])).to eq([user1, user2, user3, user4])
        expect(described_class.by_branch_ids(nil)).to eq([user1, user2, user3, user4])
      end
    end
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
