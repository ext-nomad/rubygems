module CoursesHelper
  def enrollment_button(course)
    # logic to buy
    if current_user
      if course.user == current_user
        link_to 'View analytics', course_path(course), class: 'btn btn-info'
      elsif course.enrollments.where(user: current_user).any?
        link_to 'Keep learning', course_path(course), class: 'btn btn-info'
      elsif course.price.positive?
        link_to number_to_currency(course.price), new_course_enrollment_path(course), class: 'btn btn-success'
      else
        link_to 'Free', new_course_enrollment_path(course), class: 'btn btn-success'
      end
    else
      link_to 'Check price', course_path(course), class: 'btn btn-md btn-success'
    end
  end

  def review_button(course)
    user_course = course.enrollments.where(user: current_user)

    if current_user
      if user_course.any?
        if user_course.pending_review.any?
          link_to 'Add a review', edit_enrollment_path(user_course.first), class: 'btn btn-warning'
        else
          link_to 'Thanks for your review!', enrollment_path(user_course.first)
        end
      end
    end
  end
end
