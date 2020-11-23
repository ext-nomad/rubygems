module LessonsHelper
  def lessons_pic(lesson)
    if current_user && policy(lesson).show?
      if lesson.viewed(current_user) == true
        "<i class='text-success fa fa-check-square'></i>".html_safe
      else
        "<i class='text-danger fa fa-check-square'></i>".html_safe
      end
    else
      "<i class='fa fa-lock'></i>".html_safe
    end
  end
end
