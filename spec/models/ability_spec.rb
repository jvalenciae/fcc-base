# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  subject { described_class.new(user) }

  let(:user) { create(:user) }
  let(:organization) { create(:organization) }
  let(:branch) { create(:branch, organization: organization) }
  let(:ally) { create(:ally, organization: organization) }

  context 'when user is a super admin' do
    let(:user) { create(:user, :super_admin) }

    # User permissions
    it { is_expected.to be_able_to(:manage, User) }

    # Organization permissions
    it { is_expected.to be_able_to(:manage, Organization) }

    # Ally permissions
    it { is_expected.to be_able_to(:manage, Ally) }

    # Branch permissions
    it { is_expected.to be_able_to(:manage, Branch) }
  end

  context 'when user is an admin' do
    let(:user) { create(:user, :admin, organization: organization) }
    let(:member_user) { create(:user, organization: organization) } # User in admin's organizations
    let(:user_in_other_organization) { create(:user) } # User not in admin's organizations

    # User permissions
    it { is_expected.to be_able_to(:create, member_user, organization_id: organization.id) }
    it { is_expected.to be_able_to(:update, member_user) }
    it { is_expected.to be_able_to(:destroy, member_user) }
    it { is_expected.to be_able_to(:read, member_user) }
    it { is_expected.not_to be_able_to(:create, user_in_other_organization) }
    it { is_expected.not_to be_able_to(:update, user_in_other_organization) }
    it { is_expected.not_to be_able_to(:destroy, user_in_other_organization) }

    # Organization permissions
    it { is_expected.to be_able_to(:read, organization) }

    # Ally permissions
    it { is_expected.to be_able_to(:manage, ally) }

    # Branch permissions
    it { is_expected.to be_able_to(:manage, branch) }
  end

  context 'when user is a member' do
    let(:user) { create(:user, organization: organization, branches: [branch]) }

    let(:other_user) { create(:user) } # Another user, not the same as the logged-in user

    # User permissions
    it { is_expected.to be_able_to(:read, user) }
    it { is_expected.to be_able_to(:update, user) }
    it { is_expected.not_to be_able_to(:read, other_user) }
    it { is_expected.not_to be_able_to(:update, other_user) }

    # Organization permissions
    it { is_expected.to be_able_to(:read, organization) }

    # Ally permissions
    it { is_expected.to be_able_to(:read, ally) }

    # Branch permissions
    it { is_expected.to be_able_to(:read, branch) }
  end
end
