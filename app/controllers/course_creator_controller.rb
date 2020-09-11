class CourseCreatorController < ApplicationController
  include Wicked::Wizard
  before_action :set_progress, only: %i[show]

  steps :basic_info, :details

  def show
    # @user = current_user

    # case step
    # when :basic_info

    # when :details

    # end
    render_wizard
  end

  def finish_wizard_path
    courses_path
  end

  private

  def set_progress
    @progress = if wizard_steps.any? && wizard_steps.index(step).present?
                  ((wizard_steps.index(step) + 1).to_d / wizard_steps.count) * 100
                else
                  0
                end
  end
end
