module CoursesHelper
  def enrollment_button(course)
    # logic to buy
    if current_user
      if course.user == current_user
        link_to t('course.buttons.analytics'), analytics_course_path(course), class: 'btn btn-info'
      elsif course.enrollments.where(user: current_user).any?
        certificate_button(course)
      elsif course.price.positive?
        link_to number_to_currency(course.price), new_course_enrollment_path(course), class: 'btn btn-success'
      else
        link_to t('course.buttons.free'), new_course_enrollment_path(course), class: 'btn btn-success'
      end
    else
      link_to t('course.buttons.check'), new_course_enrollment_path(course), class: 'btn btn-md btn-success'
    end
  end

  def review_button(course)
    user_course = course.enrollments.where(user: current_user)
    if current_user
      if user_course.any?
        if user_course.pending_review.any?
          link_to edit_enrollment_path(user_course.first) do
            t('course.buttons.review')
          end
        else
          link_to enrollment_path(user_course.first) do
            t('course.buttons.reviewed')
          end
        end
      end
    end
  end

  def certificate_button(course)
    if course.progress(current_user) == 100
      link_to certificate_enrollment_path(course.enrollments.where(user: current_user).first, format: :pdf), class: 'btn btn-sm btn-danger' do
        "<i class='fa fa-file-pdf'></i>".html_safe + ' ' + t('course.buttons.certificate')
      end
    else
      link_to course_path(course), class: 'btn btn-sm btn-info' do
        t('course.buttons.continue')
        # "<i class='fa fa-spinner'></i>".html_safe + ' ' + number_to_percentage(course.progress(current_user), precision: 0)
      end
    end
  end
end
