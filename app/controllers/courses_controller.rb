# frozen_string_literal: true

class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_course, only: %i[show destroy approve unapprove analytics]

  def index
    @ransack_path = courses_path
    @ransack_courses = Course.published.approved.ransack(params[:courses_search], search_key: :courses_search)

    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, course_tags: :tag))
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
  end

  def learning
    @ransack_path = learning_courses_path
    @ransack_courses = Course
                       .joins(:enrollments)
                       .where(enrollments: { user: current_user })
                       .ransack(params[:courses_search],
                                search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, course_tags: :tag))
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)

    render 'index'
  end

  def teaching
    @ransack_path = teaching_courses_path
    @ransack_courses = Course
                       .where(user: current_user)
                       .ransack(params[:courses_search],
                                search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, course_tags: :tag))
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)

    render 'index'
  end

  def pending_review
    @ransack_path = pending_review_courses_path
    @ransack_courses = Course
                       .joins(:enrollments)
                       .merge(Enrollment.pending_review.where(user: current_user))
                       .ransack(params[:courses_search],
                                search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, course_tags: :tag))
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)

    render 'index'
  end

  def unapproved
    @ransack_path = unapproved_courses_path
    @ransack_courses = Course
                       .unapproved
                       .ransack(params[:courses_search],
                                search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, course_tags: :tag))
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)

    render 'index'
  end

  def approve
    authorize @course, :approve?
    @course.update_attribute(:approved, true)
    redirect_to @course, notice: 'Course approved and visible'
  end

  def unapprove
    authorize @course, :approve?
    @course.update_attribute(:approved, false)
    redirect_to @course, notice: 'Course unapproved and hidden'
  end

  def analytics
    authorize @course, :owner?
  end

  def show
    authorize @course
    @lessons = @course.lessons.rank(:row_order)
    @enrollments_with_review = @course.enrollments.reviewed
  end

  def new
    @course = Course.new
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    authorize @course
  end

  def create
    @course = Course.new(course_params)
    @course.user = current_user
    @course.description = 'Dummy text'
    @course.short_description = 'Curriculum description'

    authorize @course

    if @course.save
      redirect_to course_course_wizard_index_path(@course), notice: 'Course was successfully created.'
    else
      @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
      render :new
    end
  end

  def destroy
    authorize @course

    if @course.destroy
      redirect_to courses_url, notice: 'Course was successfully destroyed.'
    else
      redirect_to @course, alert: 'Course has enrollments. Can not be deleted.'
    end
  end

  private

  def set_course
    @course = Course.friendly.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:title, :description, :short_description, :price, :published, :language, :level, :avatar, tag_ids: [])
  end
end
