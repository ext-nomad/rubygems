# frozen_string_literal: true

class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_course, only: %i[show destroy approve publish analytics]
  before_action :set_tags, only: %i[index learning teaching pending_review unapproved new create]

  def index
    @ransack_path = courses_path
    @ransack_courses = Course.published.approved.ransack(params[:courses_search], search_key: :courses_search)
    prepare_index
  end

  def learning
    @ransack_path = learning_courses_path
    @ransack_courses = Course
                       .joins(:enrollments)
                       .where(enrollments: { user: current_user })
                       .ransack(params[:courses_search],
                                search_key: :courses_search)
    prepare_index
    render 'index'
  end

  def teaching
    @ransack_path = teaching_courses_path
    @ransack_courses = Course
                       .where(user: current_user)
                       .ransack(params[:courses_search],
                                search_key: :courses_search)
    prepare_index
    render 'index'
  end

  def pending_review
    @ransack_path = pending_review_courses_path
    @ransack_courses = Course
                       .joins(:enrollments)
                       .merge(Enrollment.pending_review.where(user: current_user))
                       .ransack(params[:courses_search],
                                search_key: :courses_search)
    prepare_index
    render 'index'
  end

  def unapproved
    @ransack_path = unapproved_courses_path
    @ransack_courses = Course
                       .unapproved
                       .ransack(params[:courses_search],
                                search_key: :courses_search)
    prepare_index
    render 'index'
  end

  def approve
    authorize @course, :approve?
    if @course.approved?
      @course.update_attribute(:approved, false)
      flash[:alert] = 'Course unapproved and hidden'
    else
      @course.update_attribute(:approved, true)
      flash[:notice] = 'Course approved and visible'
    end
    redirect_to @course
  end

  def publish
    authorize @course, :owner?
    if @course.published?
      @course.update_attribute(:published, false)
      flash[:alert] = 'Course unpublished'
    else
      @course.update_attribute(:published, true)
      flash[:notice] = 'Course published'
    end
    redirect_to @course
  end

  def analytics
    authorize @course, :owner?
  end

  def show
    authorize @course
    @chapters = @course.chapters.rank(:row_order)
    @lessons = @course.lessons.rank(:row_order)
    @reviews = @course.enrollments.reviewed
  end

  def new
    @course = Course.new
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

  def set_tags
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
  end

  def prepare_index
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, course_tags: :tag))
  end

  def course_params
    params.require(:course).permit(:title, :description, :short_description, :price, :published, :language, :level, :avatar, tag_ids: [])
  end
end
