class LessonPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    @user.has_role?(:admin) ||
      @record.course.user == @user ||
      @record.course.bought(@user) == true
  end

  def edit?
    @user.present? && @record.course.user == @user
  end

  def update?
    @record.course.user == @user
  end

  def new?
    @record.course.user == @user
  end

  def create?
    @record.course.user == @user
  end

  def destroy?
    @record.course.user == @user
  end
end
