class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def edit?
    @user.has_role?(:admin) || @record.user == @user
  end

  def update?
    @user.has_role?(:admin) || @record.user == @user
  end

  def new?
    @user.has_role? :teacher
  end

  def create?
    @record.course.user_id == @user.id
  end

  def destroy?
    @user.has_role?(:admin) || @record.user == @user
  end
end
