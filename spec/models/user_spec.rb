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
    describe 'before_validation :set_random_password, on: :create' do
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

    describe 'after_create :generate_custom_reset_password_token' do
      before do
        allow(Devise.token_generator).to receive(:generate).and_return(%w[raw hashed])
      end

      context 'when user is a created' do
        let(:member_user) { create(:user) }

        it 'generates a reset password token with custom expiration' do
          expect(member_user.reset_password_token).to eq('hashed')
          expect(member_user.reset_password_sent_at).to be > Time.now.utc
        end
      end
    end
  end

  describe 'associations' do
    # it { is_expected.to belong_to(:organization).optional(true) }
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
  end

  describe 'constants' do
    it 'returns all roles listed in ROLES constant' do
      all_roles = { super_admin: 0, user: 1 }.with_indifferent_access
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
        expect(described_class.search_by_q('John')).to contain_exactly(user1)
        expect(described_class.search_by_q('Smith')).to contain_exactly(user2)
        expect(described_class.search_by_q('55555')).to contain_exactly(user3)
      end

      it 'ignores accents in the search' do
        expect(described_class.search_by_q('Álice')).to contain_exactly(user3)
      end
    end

    describe '.by_role' do
      let!(:super_admin_user) { create(:user, :super_admin) }
      let!(:user) { create(:user) }

      it 'returns users with the given role' do
        expect(described_class.by_role('super_admin')).to contain_exactly(super_admin_user)
        expect(described_class.by_role('user')).to contain_exactly(user)
      end

      it 'returns all users when role is blank' do
        expect(described_class.by_role('')).to contain_exactly(super_admin_user, user)
        expect(described_class.by_role(nil)).to contain_exactly(super_admin_user, user)
      end
    end
  end

  describe '#super_admin?' do
    let(:user) { build(:user, role: 'super_admin') }

    it 'returns true if the role is a super_admin' do
      expect(user.super_admin?).to be(true)
    end

    it 'returns false if the role is not a super_admin' do
      user.role = 'user'
      expect(user.super_admin?).to be(false)
    end
  end

  describe '#user?' do
    let(:user) { build(:user, role: 'user') }

    it 'returns true if the role is a user' do
      expect(user.user?).to be(true)
    end

    it 'returns false if the role is not a user' do
      user.role = 'super_admin'
      expect(user.user?).to be(false)
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
