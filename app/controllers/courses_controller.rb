# frozen_string_literal: true

class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_course, only: %i[show edit update destroy approve unapprove analytics]

  def index
    # @courses =
    #   if params[:title]
    #     Course.where('title ILIKE ?', "%#{params[:title]}%") # case-insensitive
    #   else
    #     Course.all

    #     @q = Course.ransack(params[:q])
    #     @courses = @q.result.includes(:user)
    #   end
    @ransack_path = courses_path
    @ransack_courses = Course.published.approved.ransack(params[:courses_search], search_key: :courses_search)
    # @courses = @ransack_courses.result.includes(:user)

    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, course_tags: :tag))
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
  end

  def purchased
    @ransack_path = purchased_courses_path
    @ransack_courses = Course
                       .joins(:enrollments)
                       .where(enrollments: { user: current_user })
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

  def created
    @ransack_path = created_courses_path
    @ransack_courses = Course
                       .where(user: current_user)
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
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "#{@course.title}, #{current_user.email}",
               page_size: 'A4',
               template: 'courses/show.pdf.haml',
               layout: 'pdf.html.haml',
               orientation: 'Portrait',
               lowquality: true,
               zoom: 1,
               dpi: 75
      end
    end
  end

  def new
    @course = Course.new
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    authorize @course
  end

  def edit
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    authorize @course
  end

  def create
    @course = Course.new(course_params)
    @course.user = current_user
    authorize @course

    if @course.save
      redirect_to @course, notice: 'Course was successfully created.'
    else
      @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
      render :new
    end
  end

  def update
    authorize @course

    if @course.update(course_params)
      redirect_to @course, notice: 'Course was successfully updated.'
    else
      @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
      render :edit
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
