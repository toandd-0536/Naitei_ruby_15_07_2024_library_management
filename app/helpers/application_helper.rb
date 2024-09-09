module ApplicationHelper
  include Pagy::Frontend

  def without_field_error_proc
    original_field_error_proc = ActionView::Base.field_error_proc
    ActionView::Base.field_error_proc = proc{|html_tag, _| html_tag}
    yield
    ActionView::Base.field_error_proc = original_field_error_proc
  end

  def nav_link_to paths, class_active = "active", options = {}, &block
    paths = [paths] unless paths.is_a?(Array)
    active_class = paths.any?{|path| current_page?(path)} ? class_active : ""
    options[:class] = [options[:class], active_class].compact.join(" ")

    link_to paths.first, options, &block
  end

  def render_flash_message key, message
    case key
    when "notice"
      render "shared/toast_success", msg: message
    when "alert"
      render "shared/toast_error", msg: message
    end
  end

  def status_background_class status
    status_classes = {
      pending: "bg-primary",
      cancel: "bg-secondary",
      confirm: "bg-success",
      returned: "bg-info",
      overdue: "bg-warning",
      lost: "bg-danger"
    }

    status_classes[status.to_sym] || "bg-light"
  end

  def display_notification notification
    notificationable = notification.notificationable

    case notification.notificationable_type
    when "Episode"
      link_to(
        notificationable.name,
        book_episode_path(notificationable.book, notificationable),
        class: "font-weight-bold text-primary d-block"
      )
    else
      notification.content
    end
  end

  def unread_notifications_count
    count = current_user.notifications.unread.count
    return unless count.positive?

    content_tag(:span, count, class: "badge badge-warning")
  end
end
