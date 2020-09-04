# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index privacy_policy]
  def index
    @purchased_courses = Course.purchased.where(enrollments: { user: current_user }).limit(3)
    @popular = Course.popular.published.approved
    @top_rated = Course.top_rated.published.approved
    @latest = Course.latest.published.approved
    @latest_good_review = Enrollment.reviewed.latest_good_reviews
  end

  def activity
    if current_user.has_role?(:admin)
      @pagy, @activities = pagy(PublicActivity::Activity.all.order(created_at: :desc))
    else
      redirect_to root_path, alert: 'You are not authorized to access this page'
    end
  end

  def analytics
    if current_user.has_role?(:admin)
      # @users = User.all
      # @enrollments = Enrollment.all
      # @courses = Course.all
    else
      redirect_to root_path, alert: 'You are not authorized to access this page'
    end
  end

  def privacy_policy; end
end
