# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the user here. For example:
    #
    #   return unless user.present?
    #   can :read, :all
    #   return unless user.admin?
    #   can :manage, :all
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md

    if user.super_admin?
      define_super_admin_abilities(user)
    elsif user.admin?
      define_admin_abilities(user)
    elsif user.member?
      define_member_abilities(user)
    end
  end

  private

  def define_super_admin_abilities(_user)
    can :manage, User
    can :manage, Organization
    can :manage, Ally
    can :manage, Branch
  end

  def define_admin_abilities(user)
    can %i[create update destroy], User, { organization_id: user.organization_id, role: User::MEMBER_ROLES.keys }
    can :read, User, { organization_id: user.organization_id }
    can :read, Organization, { id: user.organization_id }
    can :manage, Ally, { organization_id: user.organization_id }
    can :manage, Branch, { organization_id: user.organization_id }
  end

  def define_member_abilities(user)
    can %i[read update], User, { id: user.id, role: User::MEMBER_ROLES.keys }
    # can :create, [Participant, ParticipantGroup, User], user: user
    can :read, Organization, { id: user.organization_id }
    can :read, Ally, { organization_id: user.organization_id }
    can :read, Branch, { organization_id: user.organization_id }
  end
end
