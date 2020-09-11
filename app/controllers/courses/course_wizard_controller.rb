class Courses::CourseWizardController < ApplicationController
  include Wicked::Wizard
  before_action :set_progress, only: %i[show update]
  before_action :set_course, only: %i[show update finish_wizard_path]

  steps :basic_info, :details, :publish

  def show
    @user = current_user
    authorize @course, :edit?
    case step
    when :publish
      @tags = Tag.all
    end
    render_wizard
  end

  def update
    authorize @course, :edit?
    case step
    when :publish
      @tags = Tag.all
    end
    @course.update_attributes(course_params)
    render_wizard @course
  end

  def finish_wizard_path
    # courses_path
    authorize @course, :edit?
    # @course.update_attributes(course_params)
    # @course.save(course_params)
    # render_wizard @course
    course_path(@course)
  end

  private

  def set_progress
    @progress = if wizard_steps.any? && wizard_steps.index(step).present?
                  ((wizard_steps.index(step) + 1).to_d / wizard_steps.count) * 100
                else
                  0
                end
  end

  def set_course
    @course = Course.friendly.find params[:course_id]
  end

  def course_params
    params.require(:course).permit(:title, :description, :short_description, :price, :published, :language, :level, :avatar, tag_ids: [])
  end
end
