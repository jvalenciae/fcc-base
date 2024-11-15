# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  subject { described_class.new(user) }

  let(:user) { create(:user) }
  let(:organization) { create(:organization) }
  let(:branch) { create(:branch, organization: organization) }
  let(:ally) { create(:ally, organization: organization) }
  let(:group) { create(:group, branch: branch) }
  let(:student) { create(:student, group: group, branch: branch) }
  let(:supervisor) { create(:supervisor, student: student) }
  let(:group_attendance) { create(:group_attendance, group: group) }
  let(:student_attendance) { create(:student_attendance, group_attendance: group_attendance, student: student) }

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

    # Group permissions
    it { is_expected.to be_able_to(:manage, Group) }

    # Student permissions
    it { is_expected.to be_able_to(:manage, Student) }

    # Supervisor permissions
    it { is_expected.to be_able_to(:manage, Supervisor) }

    # GroupAttendance permissions
    it { is_expected.to be_able_to(:manage, GroupAttendance) }

    # StudentAttendance permissions
    it { is_expected.to be_able_to(:manage, StudentAttendance) }

    # Survey permissions
    it { is_expected.to be_able_to(:manage, Survey) }

    # SurveyResponse permissions
    it { is_expected.to be_able_to(:manage, SurveyResponse) }
  end

  context 'when user is an admin' do
    let(:user) { create(:user, :admin, organization: organization) }
    let(:member_user) { create(:user, organization: organization) } # User in admin's organizations
    let(:admin_user) { create(:user, :admin, organization: organization) } # Admin User in admin's organizations
    let(:user_in_other_organization) { create(:user) } # User not in admin's organizations
    let(:survey) { create(:survey, organization: organization) }
    let(:survey_in_other_organization) { create(:survey) }
    let(:default_survey) { create(:survey, organization: organization, default: true) }
    let(:survey_response) { create(:survey_response, survey: survey) }
    let(:default_survey_response) { create(:survey_response, survey: default_survey) }
    let(:unauthorized_survey_response) { create(:survey_response, survey: survey_in_other_organization) }

    # User permissions
    it { is_expected.to be_able_to(:create, member_user, organization_id: organization.id) }
    it { is_expected.to be_able_to(:update, member_user) }
    it { is_expected.to be_able_to(:destroy, member_user) }
    it { is_expected.to be_able_to(:read, member_user) }
    it { is_expected.not_to be_able_to(:create, admin_user) }
    it { is_expected.to be_able_to(:update, admin_user) }
    it { is_expected.to be_able_to(:destroy, admin_user) }
    it { is_expected.not_to be_able_to(:create, user_in_other_organization) }
    it { is_expected.not_to be_able_to(:update, user_in_other_organization) }
    it { is_expected.not_to be_able_to(:destroy, user_in_other_organization) }

    # Organization permissions
    it { is_expected.to be_able_to(:read, organization) }

    # Ally permissions
    it { is_expected.to be_able_to(:manage, ally) }

    # Branch permissions
    it { is_expected.to be_able_to(:manage, branch) }

    # Group permissions
    it { is_expected.to be_able_to(:manage, group) }

    # Student permissions
    it { is_expected.to be_able_to(:manage, student) }

    # Supervisor permissions
    it { is_expected.to be_able_to(:manage, supervisor) }

    # GroupAttendance permissions
    it { is_expected.to be_able_to(:manage, group_attendance) }

    # StudentAttendance permissions
    it { is_expected.to be_able_to(:manage, student_attendance) }

    # Survey permissions
    it { is_expected.to be_able_to(:read, survey) }
    it { is_expected.to be_able_to(:read, default_survey) }
    it { is_expected.not_to be_able_to(:read, survey_in_other_organization) }

    # Survey permissions
    it { is_expected.to be_able_to(:read, survey_response) }
    it { is_expected.to be_able_to(:read, default_survey_response) }
    it { is_expected.not_to be_able_to(:read, unauthorized_survey_response) }
  end

  context 'when user is a member' do
    let(:user) { create(:user, organization: organization, branches: [branch]) }

    let(:other_user) { create(:user) } # Another user, not the same as the logged-in user
    let(:survey) { create(:survey, organization: organization) }
    let(:survey_in_other_organization) { create(:survey) }
    let(:default_survey) { create(:survey, organization: organization, default: true) }
    let(:survey_response) { create(:survey_response, survey: survey) }
    let(:default_survey_response) { create(:survey_response, survey: default_survey) }
    let(:unauthorized_survey_response) { create(:survey_response, survey: survey_in_other_organization) }

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

    # Group permissions
    it { is_expected.to be_able_to(:manage, group) }

    # Student permissions
    it { is_expected.to be_able_to(:manage, student) }

    # Supervisor permissions
    it { is_expected.to be_able_to(:manage, supervisor) }

    # GroupAttendance permissions
    it { is_expected.to be_able_to(:manage, group_attendance) }

    # StudentAttendance permissions
    it { is_expected.to be_able_to(:manage, student_attendance) }

    # Survey permissions
    it { is_expected.to be_able_to(:read, survey) }
    it { is_expected.to be_able_to(:read, default_survey) }
    it { is_expected.not_to be_able_to(:read, survey_in_other_organization) }

    # Survey permissions
    it { is_expected.to be_able_to(:read, survey_response) }
    it { is_expected.to be_able_to(:read, default_survey_response) }
    it { is_expected.not_to be_able_to(:read, unauthorized_survey_response) }
  end
end
