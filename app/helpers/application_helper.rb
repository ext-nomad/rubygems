module ApplicationHelper
  include Pagy::Frontend

  def crud_label(key)
    case key
    when 'create'
      "<i class='fa fa-plus'></i>".html_safe
    when 'update'
      "<i class='fa fa-pen'></i>".html_safe
    when 'destroy'
      "<i class='fa fa-trash'></i>".html_safe
    end
  end

  def model_label(model)
    case model
    when 'Course'
      "<i class='fa fa-graduation-cap'></i>".html_safe
    when 'Lesson'
      "<i class='fa fa-tasks'></i>".html_safe
    when 'Enrollment'
      "<i class='fa fa-lock-open'></i>".html_safe
    when 'Comment'
      "<i class='fa fa-comment'></i>".html_safe
    when 'User'
      "<i class='fa fa-user'></i>".html_safe
    end
  end

  def boolean_label(value)
    case value
    when true
      content_tag(:span, t('user.buttons.yes'), class: 'badge badge-success')
    when false
      content_tag(:span, t('user.buttons.no'), class: 'badge badge-danger')
    end
  end

  def active_link_to(name, path)
    content_tag(:li, class: "#{'active font-weight-bold' if current_page?(path)} nav-item") do
      link_to name, path, class: 'nav-link'
    end
  end

  def long_active_link_to(path)
    content_tag(:li, class: "#{'active font-weight-bold' if current_page?(path)} nav-item") do
      link_to path, class: 'nav-link' do
        yield
      end
    end
  end

  def dropdown_active_link(path)
    link_to path, class: "dropdown-item #{'active' if current_page?(path)}" do
      yield
    end
  end
end
