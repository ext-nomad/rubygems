# frozen_string_literal: true

class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[landing_page privacy_policy]

  def landing_page
    @popular = Course.popular.published.approved
    @top_rated = Course.top_rated.published.approved
    @latest = Course.latest.published.approved
    @latest_good_review = Enrollment.reviewed.latest_good_reviews
    @popular_tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc).limit(10)
    if current_user
      @learning_courses = Course.joins(:enrollments).where(enrollments: { user: current_user }).order(created_at: :desc).limit(2)
      @teaching_courses = current_user.courses.limit(2)
    end
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

    else
      redirect_to root_path, alert: 'You are not authorized to access this page'
    end
  end

  def privacy_policy; end
end
