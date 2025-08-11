class BugReportPolicy < ApplicationPolicy
  # Anyone can view index and show (managers, developers, QA)
  def index?
    user.has_role?(:manager) || user.has_role?(:developer) || user.has_role?("QA")
  end

  def show?
    index?  # same as index
  end

  # Only QA can create new reports
  def create?
    user.has_role?("QA")
  end

  def new?
    create?
  end

  # No one can update or destroy bug reports
  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  # Scope for index action, so each user can see reports they are allowed to
  class Scope < Scope
    def resolve
      if user.has_role?(:manager) || user.has_role?(:developer) || user.has_role?("QA")
        scope.all
      else
        scope.none
      end
    end
  end
end
