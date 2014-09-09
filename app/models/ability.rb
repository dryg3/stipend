class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
      role="guest"
    else
      user ||= User.new # guest user (not logged in)
      role=UsersRole.find_by_user_id(user.id).role.name
    end
    if role=="admin"
      can :manage, :all
    elsif role=="faculty"
      can [:update,:read],  [StudentGroup, Student, Group]
      #can :create, StudentGroup, Group
      #can :update, StudentGroup, Group
      can :manage, [Certificat,PayToMonthStudent,Order, PayCategoryToSemester]
    else
      can :read, Group
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
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
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end