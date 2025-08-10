class ProjectPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.has_role?(:manager)
  end

  def new?
    create?
  end

  def update?
    user.has_role?(:manager) && record.user_id == user.id
  end

  def edit?
    update?
  end

  def destroy?
    user.has_role?(:manager) && record.user_id == user.id
  end

  class Scope < Scope
    def resolve
      if user.has_role?(:manager)
        scope.all   # Manager sees all projects
      elsif user.has_role?(:developer)
        scope.where(developer_id: user.id)
      else
        scope.all   # Non-manager also sees all projects
      end
    end
  end
end
