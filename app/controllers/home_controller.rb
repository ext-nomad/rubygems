# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def index
    @purchased_courses = Course.joins(:enrollments).where(enrollments: { user: current_user }).order(created_at: :desc).limit(3)
    @popular = Course.popular
    @top_rated = Course.top_rated
    @latest = Course.latest
    @latest_good_review = Enrollment.reviewed.latest_good_reviews
  end

  def activity
    @activities = PublicActivity::Activity.all
  end
end
